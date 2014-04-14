class Location < ActiveRecord::Base
  belongs_to :findable, :polymorphic => true

  validates :latitude , numericality: { greater_than:  -90, less_than:  90 }, allow_nil: false, allow_blank: false, presence: true
  validates :longitude, numericality: { greater_than: -180, less_than: 180 }, allow_nil: false, allow_blank: false, presence: true

  class << self
    def all_within(latitude, longitude, offset)
      center_point = [latitude, longitude]
      box = Geocoder::Calculations.bounding_box(center_point, offset)
      Location.within_bounding_box(box)
    end
  end

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
end
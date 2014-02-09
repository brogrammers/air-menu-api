class Location < ActiveRecord::Base
  belongs_to :findable, :polymorphic => true

  validates :latitude , numericality: { greater_than:  -90, less_than:  90 }, allow_nil: false, allow_blank: false, presence: true
  validates :longitude, numericality: { greater_than: -180, less_than: 180 }, allow_nil: false, allow_blank: false, presence: true
end
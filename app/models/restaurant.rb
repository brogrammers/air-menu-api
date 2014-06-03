class Restaurant < ActiveRecord::Base
  has_many :menus, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  has_many :staff_kinds, :dependent => :destroy
  has_many :staff_members, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :opening_hours, :dependent => :destroy
  has_many :webhooks, :dependent => :destroy
  has_many :devices, :as => :notifiable, :dependent => :destroy
  has_one :address, :as => :contactable, :dependent => :destroy
  has_one :location, :as => :findable, :dependent => :destroy
  belongs_to :company

  mount_uploader :avatar, AvatarUploader unless ENV['CW_SKIP']

  def current_orders
    Order.where(:served_time => nil, :restaurant_id => self.id)
  end

  def active_menu
    @active_menu ||= Menu.find(self.active_menu_id) rescue nil
  end

  def rating
    review_array = self.reviews.to_a
    sum = review_array.inject(0) { |sum, review| sum + review.rating }
    review_array.size != 0 ? sum / review_array.size : 0.0
  end

  def online_staff_members
    StaffMember.online self.id
  end
end
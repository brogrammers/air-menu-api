class StaffMember < ActiveRecord::Base
  has_one :identity, :as => :identifiable
  belongs_to :restaurant
  belongs_to :staff_kind
  belongs_to :group
  has_many :access_tokens, :class_name => 'Doorkeeper::AccessToken', :as => :owner

  def type
    'StaffMember'
  end

  def current_orders
    # TODO: Need to add staff members to orders
    []
  end

  def company
    nil
  end

end
class User < ActiveRecord::Base
	has_one :identity, :as => :identifiable
  has_one :location, :as => :findable
  has_one :company
  has_many :applications, :class_name => 'Doorkeeper::Application', :as => :owner
  has_many :access_tokens, :class_name => 'Doorkeeper::AccessToken', :as => :owner

	validates :name, presence: true

  def owns(object)
    return owns_company object if object.class == Company
    return owns_restaurant object if object.class == Restaurant
    return owns_menu object if object.class == Menu
    return owns_menu_section object if object.class == MenuSection
    return owns_menu_item object if object.class == MenuItem
    false
  end

  def type
    self.company ? 'Owner' : 'User'
  end

  private

  def owns_company(company)
    self.company.id == company.id
  end

  def owns_restaurant(restaurant)
    self.company.restaurants.each do |owned_restaurant|
      return true if owned_restaurant.id == restaurant.id
    end
    false
  end

  def owns_menu(menu)
    owns_restaurant menu.restaurant
  end

  def owns_menu_section(menu_section)
    owns_menu menu_section.menu
  end

  def owns_menu_item(menu_item)
    owns_menu_section menu_item.menu_section
  end
end
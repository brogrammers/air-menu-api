class MenuSection < ActiveRecord::Base
  has_many :menu_items
  belongs_to :menu
  belongs_to :staff_kind
end
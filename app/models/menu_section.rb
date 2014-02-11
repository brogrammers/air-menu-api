class MenuSection < ActiveRecord::Base
  belongs_to :menu
  belongs_to :staff_kind
end
class Scope < ActiveRecord::Base
  has_many :staff_kind_scopes
  has_many :staff_kinds, :through => :staff_kind_scopes
end
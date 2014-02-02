class Identity < ActiveRecord::Base
	belongs_to :identifiable, polymorphic: true
end
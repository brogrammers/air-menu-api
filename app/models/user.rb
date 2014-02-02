class User < ActiveRecord::Base
	has_one :identifiable, as: true
end
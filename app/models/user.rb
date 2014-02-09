class User < ActiveRecord::Base
	has_one :identity, :as => :identifiable
  has_one :location, :as => :findable
  has_one :company
  has_many :applications, :class_name => 'Doorkeeper::Application', :as => :owner
  has_many :access_tokens, :class_name => 'Doorkeeper::AccessToken', :as => :owner

	validates :name, presence: true
end
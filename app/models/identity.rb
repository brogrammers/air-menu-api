require 'bcrypt'

class Identity < ActiveRecord::Base
	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

	belongs_to :identifiable, polymorphic: true

	validates :username, :email, presence: true
 	validates :username, :email, uniqueness: true
 	validates :email, :format => { :with => EMAIL_REGEX }

	before_save :encrypt_password
 	after_save :clear_password

 	def match_password(login_password)
 		password == BCrypt::Engine.hash_secret(login_password, salt)
  end

  def new_password=(password)
    @new_password = true
    self.password = password
  end

  class << self
    def authenticate!(username, password)
      identity = Identity.find_by_username(username)
      identity && identity.match_password(password) ? identity : nil
    end
  end

 	private

 	def encrypt_password
 		if @new_password
 			self.salt = BCrypt::Engine.generate_salt
 			self.password = BCrypt::Engine.hash_secret(password, salt)
 		end
 	end

 	def clear_password
    @new_password = false
 		self.password = nil
 	end
end
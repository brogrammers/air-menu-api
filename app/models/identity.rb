require 'bcrypt'

class Identity < ActiveRecord::Base
	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

	belongs_to :identifiable, polymorphic: true

	validates :username, :password, :email, presence: true
 	validates :email, uniqueness: true
 	validates :email, :format => { :with => EMAIL_REGEX }

	before_save :encrypt_password
 	after_save :clear_password

 	def match_password(login_password)
 		password == BCrypt::Engine.hash_secret(login_password, salt)
 	end

 	private

 	def encrypt_password
 		unless salt
 			self.salt = BCrypt::Engine.generate_salt
 			self.password = BCrypt::Engine.hash_secret(password, salt)
 		end
 	end

 	def clear_password
 		self.password = nil
 	end
end
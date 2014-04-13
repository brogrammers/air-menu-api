class Device < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true

  def self.authenticate(uuid, user)
    Device.where(:uuid => uuid, :notifiable_id => user.id).first
  end
end
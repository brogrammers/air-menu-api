class Device < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true

  def self.authenticate(uuid, user)
    # TODO: need to distinguish between user, staff member and group
    Device.where(:uuid => uuid, :notifiable_id => user.id).first
  end
end
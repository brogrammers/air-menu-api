class Device < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true

  def self.authenticate(uuid, user)
    if user.class == StaffMember
      device = Device.where(:uuid => uuid, :id => user.group.device_id).first if user.group
      device = Device.where(:uuid => uuid, :id => user.device_id).first if device.nil? && user.device_id
    elsif user.class == User
      device = Device.where(:uuid => uuid, :notifiable_id => user.id, :notifiable_type => user.class.to_s).first
    end
    device
  end
end
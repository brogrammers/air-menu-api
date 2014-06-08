class Device < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true

  validates :uuid, uniqueness: true

  before_destroy :reassign_group_staff_member

  def self.authenticate(uuid, user)
    if user.class == StaffMember
      device = Device.where(:uuid => uuid, :id => user.group.device_id).first if user.group
      device = Device.where(:uuid => uuid, :id => user.device_id).first if device.nil? && user.device_id
    elsif user.class == User
      device = Device.where(:uuid => uuid, :notifiable_id => user.id, :notifiable_type => user.class.to_s).first
    end
    device
  end

  def reassign_group_staff_member
    StaffMember.where(:device_id => self.id).each do |staff_member|
      staff_member.device_id = nil
      staff_member.save!
    end
    Group.where(:device_id => self.id).each do |staff_member|
      staff_member.device_id = nil
      staff_member.save!
    end
  end
end
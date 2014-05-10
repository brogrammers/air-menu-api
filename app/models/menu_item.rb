class MenuItem < ActiveRecord::Base
  belongs_to :menu_section
  belongs_to :staff_kind

  mount_uploader :avatar, AvatarUploader

  def active?
    self.menu_section.active?
  end
end
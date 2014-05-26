class Group < ActiveRecord::Base
  class MismatchError < StandardError; end
  has_many :staff_members
  belongs_to :restaurant
  belongs_to :device

  def add_staff_member!(staff_member)
    if staff_kind
      if staff_member.staff_kind.id == staff_kind.id
        self.staff_members << staff_member
      else
        raise MismatchError
      end
    else
      self.staff_members << staff_member
    end
    save!
  end

  def staff_kind
    @staff_member ||= self.staff_members.first
    @staff_member ? @staff_member.staff_kind : nil
  end

  def empty_staff_members
    self.staff_members.each do |staff_member|
      staff_member.group_id = nil
      staff_member.save!
      puts staff_member.group_id
    end
  end
end
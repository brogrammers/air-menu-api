class Notification < ActiveRecord::Base
  belongs_to :remindable, polymorphic: true

  def read!
    self.read = true
    save!
  end
end
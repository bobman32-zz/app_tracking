class App < ActiveRecord::Base
  validates :app_name, :presence => true, :uniqueness => { :scope => :user }
  validates :os, :presence => true

  has_many :versions#, #:through => :apps
  belongs_to :user

  validate :user_can_only_have_twenty

  def user_can_only_have_twenty
    if self.user.apps.count >= 20
      errors.add(:user_id, "is already tracking twenty apps")
    end
  end

end

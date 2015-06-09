class Join < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :app_id, :presence => true, :uniqueness => { :scope => :user_id}


  belongs_to :user, :foreign_key => "user_id"
  belongs_to :app, :foreign_key => "app_id"

  # validate :user_can_only_have_twenty

  # def user_can_only_have_twenty
  #    if self.user.joins.count >= 30
  #      errors.add(:user_id, "is already tracking thirty apps")
  #    end
  #  end
end

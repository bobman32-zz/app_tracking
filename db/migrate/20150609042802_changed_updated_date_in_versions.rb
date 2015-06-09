class ChangedUpdatedDateInVersions < ActiveRecord::Migration
  def change
    change_column :versions, :updated_date, :datetime
  end
end

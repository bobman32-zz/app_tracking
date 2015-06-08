class ChangeRatingFormatInVersions < ActiveRecord::Migration
  def change
    change_column :versions, :rating, :float
  end
end

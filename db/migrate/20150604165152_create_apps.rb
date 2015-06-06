class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :app_name
      t.string :os

      t.timestamps null: false
    end
  end
end

class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :app_name
      t.string :app_icon_url
      t.string :market
      t.string :publisher_name
      t.string :current_version
      t.text :description
      t.datetime :updated_date
      t.string :vertical

      t.timestamps null: false
    end
  end
end

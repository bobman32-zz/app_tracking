class AddWhatsNewtoVersions < ActiveRecord::Migration
  def change
    add_column :versions, :whats_new, :text
  end
end

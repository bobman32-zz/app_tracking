class AddTextnametoApp < ActiveRecord::Migration
  def change
      add_column :apps, :textname, :string
  end
end

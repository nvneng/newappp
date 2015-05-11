class AddUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :artistimage, :string
    add_column :users, :artistprofile, :string
  end
end

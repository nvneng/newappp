class AddUrlToSrecords < ActiveRecord::Migration
  def change
    add_column :srecords, :artistimage, :string
    add_column :srecords, :artistprofile, :string
  end
end

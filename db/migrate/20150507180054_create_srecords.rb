class CreateSrecords < ActiveRecord::Migration
  def change
    create_table :srecords do |t|
      t.string :search_string
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

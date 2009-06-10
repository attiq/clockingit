class CreatePasswords < ActiveRecord::Migration
  def self.up
    create_table :passwords do |t|
      t.integer :project_id
      t.integer :password_creator_id
      t.string :password_type
      t.string :url
      t.string :username
      t.text :password
      t.string :note
      t.timestamps
    end
  end

  def self.down
    drop_table :passwords
  end
end

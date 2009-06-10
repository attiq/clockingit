class CreatePasswordAccesses < ActiveRecord::Migration
  def self.up
    create_table :password_accesses do |t|
      t.integer :password_id
      t.integer :accessable_id
      t.datetime :accessed_at
      t.string :action
      
      t.timestamps
    end
  end

  def self.down
    drop_table :password_accesses
  end
end

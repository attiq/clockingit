class AddProjectColumns < ActiveRecord::Migration
  def self.up
    add_column :projects, :create_wiki, :boolean, :default => true
    add_column :projects, :project_manager_id, :integer
    add_column :projects, :chief_worker_id, :integer
  end

  def self.down
    remove_column :projects, :create_wiki
    remove_column :projects, :project_manager_id
    remove_column :projects, :chief_worker_id
  end
end

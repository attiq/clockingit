class AddTaskTypes < ActiveRecord::Migration
  def self.up
    say_with_time "Add Email Generatde task Type" do
      value = PropertyValue.new(:property_id => "1", :value => "Email Generated", :icon_url => "/images/task_icons/task.png" )
      value.save
    end  
    say_with_time "Add Client Deliverable task Type" do  
      value = PropertyValue.new(:property_id => "1", :value => "Client Deliverable", :icon_url => "/images/task_icons/task.png" )
      value.save
    end
  end

  def self.down
  end
end

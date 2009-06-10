# A logical grouping of milestones and tasks, belonging to a Customer / Client

class Project < ActiveRecord::Base
  belongs_to    :company
  belongs_to    :customer
  belongs_to    :owner, :class_name => "User", :foreign_key => "user_id"

  has_many      :users, :through => :project_permissions
  has_many      :project_permissions, :dependent => :destroy
  has_many      :pages, :dependent => :destroy
  has_many      :tasks
  has_many      :sheets
  has_many      :work_logs, :dependent => :destroy
  has_many      :project_files, :dependent => :destroy
  has_many      :project_folders, :dependent => :destroy
  has_many      :milestones, :dependent => :destroy, :order => "due_at asc, lower(name) asc"
  has_many      :forums, :dependent => :destroy
  has_many      :shout_channels, :dependent => :destroy

  validates_length_of           :name,  :maximum=>200
  validates_presence_of         :name

  after_create { |r|
    if r.create_forum && r.company.show_forum
      f = Forum.new
      f.company_id = r.company_id
      f.project_id = r.id
      f.name = r.full_name
      f.save
    end
    if r.create_wiki
      w = WikiPage.new
      w.company_id = r.company_id
      w.name = "#{r.name}'s wiki " 
      w.project_id = r.id
      w.lock(Time.now.utc, r.owner.id )
      w.save
       
      rev = WikiRevision.new
      rev.wiki_page = w
      rev.user = r.owner
      rev.body = "This is wiki for #{r.name} project "
      # rev.change = params[:change]
      rev.save
      
      l = w.event_logs.new
      l.company_id = w.company_id
      l.project_id = w.project_id
      l.user_id = r.owner.id
      l.event_type = w.revisions.size < 2 ? EventLog::WIKI_CREATED : EventLog::WIKI_MODIFIED
      l.created_at = rev.created_at
      # l.body = params[:change]
      l.save 
    end
  }

  def project_manager
    User.find_by_id(self.project_manager_id).name   
  end  
      
  def chief_worker
    User.find_by_id(self.chief_worker_id).name   
  end  
  
  def full_name
    "#{customer.name} / #{name}"
  end

  def to_css_name
    "#{self.name.underscore.dasherize.gsub(/[ \."',]/,'-')} #{self.customer.name.underscore.dasherize.gsub(/[ \.'",]/,'-')}"
  end

  def total_estimate
    tasks.sum(:duration).to_i
  end 

  def work_done
    tasks.sum(:worked_minutes).to_i
  end 

  def overtime
    tasks.sum('worked_minutes - duration', :conditions => "worked_minutes > duration").to_i
  end

  def total_tasks_count
    if self.total_tasks.nil?
      self.total_tasks = tasks.count
      self.save
    end
    total_tasks
  end

  def open_tasks_count
    if self.open_tasks.nil?
      self.open_tasks = tasks.count(:conditions => ["completed_at IS NULL"])
      self.save
    end
    open_tasks
  end

  def total_milestones_count
    if self.total_milestones.nil?
      self.total_milestones = milestones.count
      self.save
    end
    total_milestones
  end

  def open_milestones_count
    if self.open_milestones.nil?
      self.open_milestones = milestones.count(:conditions => ["completed_at IS NULL"])
      self.save
    end
    open_milestones
  end

  ###
  # Updates the critical, normal and low counts for this project.
  # Also updates open and total tasks.
  ###
  def update_project_stats
    self.critical_count = tasks.select { |t| t.critical? }.length
    self.normal_count = tasks.select { |t| t.normal? }.length
    self.low_count = tasks.select { |t| t.low? }.length
    self.open_tasks = nil
    self.total_tasks = nil
  end
  
  def create_tasks(pro,user)
    pro.tasks.each do |task|   
      # tags = task.tags
      new_task = user.company.tasks.new
      new_task.name = task.name
      new_task.company_id = user.company_id
      new_task.project_id = self.id
      new_task.updated_by_id = user.id
      new_task.creator_id = user.id
      new_task.requested_by = task.requested_by
      new_task.milestone_id = task.milestone_id
      # new_task.due_at  = (task.due_at - pro.created_at )+Date.today
      new_task.duration = task.duration 
      # new_task.set_tags(tags) 
      new_task.set_task_num(user.company_id)
      new_task.duration = 0 if new_task.duration.nil?
      if new_task.save
        # session[:last_project_id] = @task.project_id
        # new_task.set_watcher_attributes(params[:watchers],user)
        # @task.set_owner_attributes(params[:users])
        # @task.set_dependency_attributes(params[:dependencies], current_project_ids)
        # @task.set_resource_attributes(params[:resource])
        #  create_attachments(new_task)
      end 
    end
  end

end

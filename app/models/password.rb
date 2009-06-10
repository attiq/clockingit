class Password < ActiveRecord::Base
  
  belongs_to :project
  has_many :password_accesses
  
  validates_presence_of :project_id, :password_creator_id, :password_type, :username, :password 
#  validates_format_of :url, :with => /^((http|https):\/\/)*[a-z0-9_-]{1,}\.*[a-z0-9_-]{1,}\.[a-z]{2,4}\/*$/i

  
end

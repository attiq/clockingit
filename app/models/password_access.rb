class PasswordAccess < ActiveRecord::Base
  belongs_to :user
  belongs_to :password
  
end

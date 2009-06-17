class PasswordsController < ApplicationController
  # GET /passwords
  # GET /passwords.xml
 
  def index
    unless params[:project_id].nil?
      @project=Project.find_by_id(params[:project_id])      
      @passwords = @project.passwords
    else  
     @passwords = Password.find(:all)
    end
    
   # @passwords =  @passwords.paginate(:page => params[:page],:per_page => 10 );
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @passwords }
    end
  end

  # GET /passwords/1
  # GET /passwords/1.xml
  def show
    @password = Password.find(params[:id])
    @p_access  = PasswordAccess.new(:password_id => @password.id, :accessable_id => current_user.id, :accessed_at => DateTime.now, :action => "Viewed" )
    @p_access.save
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @password }
    end
  end

  def password_log
    @password = Password.find(params[:id])
    @password_log = @password.password_accesses
  
  end
   
  def destroy_password_log
    
    @password_log = PasswordAccess.find_by_id(params[:id])
    @password = Password.find_by_id(@password_log.password.id)
    @password_log.destroy
    redirect_to :action => "password_log",:id => @password.id
 
  end
  
  # GET /passwords/new
  # GET /passwords/new.xml
  def new
    @password = Password.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @password }
    end
  end

  # GET /passwords/1/edit
  def edit
    @password = Password.find(params[:id])
  end

  # POST /passwords
  # POST /passwords.xml
  def create
    @password = Password.new(params[:password])

    respond_to do |format|
      if @password.save
        flash[:notice] = 'Password was successfully created.'
        format.html { redirect_to(passwords_path) }
        format.xml  { render :xml => @password, :status => :created, :location => @password }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @password.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /passwords/1
  # PUT /passwords/1.xml
  def update
    @password = Password.find(params[:id])

    respond_to do |format|
      if @password.update_attributes(params[:password])
        @p_access  = PasswordAccess.new(:password_id => @password.id, :accessable_id => current_user.id, :accessed_at => DateTime.now, :action => "Updated" )
        @p_access.save
        flash[:notice] = 'Password was successfully updated.'
        format.html { redirect_to(passwords_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @password.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /passwords/1
  # DELETE /passwords/1.xml
  def destroy
    @password = Password.find(params[:id])
    @password.destroy

    respond_to do |format|
      format.html { redirect_to(passwords_url) }
      format.xml  { head :ok }
    end
  end
end

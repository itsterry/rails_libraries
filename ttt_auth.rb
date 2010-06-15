module TttAuth
  
  def intended_destination
     return {:controller=>session[:intended_controller],:action=>session[:intended_action],:id=>session[:intended_id]}
  end

  def check_authentication(goto=signin_auth)
    if @loggeduser.nil?
      session[:user]=nil
      flash[:warning] = "Please sign in first"
      set_intended_destination
      return redirect_to(signin_auth)
    end
    #if @loggeduser.password_expired?
    #  unless params["controller"]=='account'
    #    flash[:warning] = "Your password has expired. Please reset it."
    #    return redirect_to(:controller=>'account')
    #  end
    #end
  end

  def check_authorization
    if @loggeduser.nil?
      return false
    end
    unless @loggeduser.is_authorized?(self.class.controller_path,action_name)
      unless @loggeduser.is_admin?
        flash[:error] = "You are not authorized to view the page you requested ("+self.class.controller_path+":"+action_name+")"
        begin
          redirect_to :back
        rescue
          set_intended_destination
          redirect_to :root
        end
        return false
      end
    end    
  end

  def default_destination
    if params[:reroute]
      return {:controller=>params[:reroute]}
    else
      return {:controller=>'home'}
    end
  end

  def find_user
    if session[:user]
      if User.exists?(session[:user])
        @loggeduser=User.find(session[:user])
        if @loggeduser.is_admin? or @loggeduser.is_terry?
          @admin=1
        end
      else
        @loggeduser=nil
      end
    end
  end

  def set_globals
     @action_name = action_name
     @controller_name = controller_name 
  end
  
  def set_intended_destination
     session[:intended_action] = action_name
     session[:intended_controller] = controller_name 
     session[:intended_id] = params[:id] 
  end

  def signin_auth
    if params[:reroute_signin]
      return {:controller=>params[:reroute_signin]}
    else
      return {:controller=>'signin'}
    end
  end


end
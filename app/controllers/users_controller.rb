class UsersController < ApplicationController
  
  # render new.rhtml
  def new
    @user = User.new
  end
  def show
    if (!current_user.nil?)
      @user = User.find(current_user.id)
    else
      flash.now[:error]  = "You must be logged in to do that."
      redirect_to root_url
    end
  end
  
  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Account was successfully edited.'
        format.html { redirect_to my_account_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
      flash.clear
    end
  end
 
  def create
    logout_keeping_session!
    @user = User.create(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/', :notice => "Thanks for signing up!  We're sending you an email with your activation code.")
    else
      flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  #Reset password methods
  def reset_password

    @user = User.find(:first, :conditions => ['email = ?', params[:email]])
    if !params[:email].nil?
      if !@user.nil?
        resetpass = newpass(8)
        @user.password = resetpass
        @user.password_confirmation = resetpass
        if @user.save!
          PostOffice.deliver_reset_password_msg(@user, resetpass) 
          redirect_to home_path('home')
          flash[:notice] = "Password successfully reset.  Please check your email for your new password."
        else
          flash[:alert] = "Could not successfully reset your password  Please contact an administrator." 
          redirect_to home_path('home')
        end
      else   
        flash[:alert] = "Could not find the email specified." 
        render :action => 'reset_password'
      end
    else
      render :action => 'reset_password'
    end
  end

  def newpass( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("1".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def change_password
    @user = User.find(current_user.id)

    if !params[:old_password].nil?
      if User.authenticate(current_user.login, params[:old_password])
        if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
          @user.password_confirmation = params[:password_confirmation]
          @user.password = params[:password]

          if @user.save!
            flash[:notice] = "Password successfully updated.  An email has been sent to your account."
            render :action => 'my_account'
          else
            flash[:alert] = "Password not changed."
            render :action => 'change_password'
          end

        else
          flash[:alert] = "New password does not match." 
          render :action => 'change_password'
        end
      else
        flash[:alert] = "Old password incorrect." 
        render :action => 'change_password'
      end
    else
      render :action => 'change_password'
    end
    flash.clear
  end

end

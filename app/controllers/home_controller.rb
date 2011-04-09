class HomeController < ApplicationController
  def index
    session[:event] = nil
    @announcements = Announcement.all
    @upcoming_events = Event.upcoming
  end

  def directory
    @users = User.all
  end

  def contact
    @zones = Zone.all
  end
  def administration
  end

  def my_events
    @registrations = Registration.where(:user_id => current_user.id)
  end
  
  def send_contact_message
    eboard = PositionMember.eboard
    
    for position in eboard
      user = User.where(:id => position.user_id)
      if user[0].admin?
        PostOffice.contact_message(user[0], params[:name], params[:email], params[:message]).deliver
      end
    end
    
    
    redirect_to home_path
  end

end

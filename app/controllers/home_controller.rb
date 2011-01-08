class HomeController < ApplicationController
  def index
    session[:event] = nil
    @announcements = Announcement.all
    @events = Event.all
  end

  def directory
    @users = User.all
  end
  
  def officers
    @zones = Zone.all
  end

  def contact

  end

  def my_events
    @registrations = Registration.find(:all, :conditions => ['user_id = ?', current_user.id])
  end
end

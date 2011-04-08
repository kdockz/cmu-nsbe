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

end

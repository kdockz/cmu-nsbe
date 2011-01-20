class HomeController < ApplicationController
  def index
    session[:event] = nil
    @announcements = Announcement.all
    @todays_events = Event.today
    @upcoming_events = Event.upcoming
  end

  def directory
    @users = User.all
  end

  def chapter
    @zones = Zone.all
  end

  def contact

  end

  def my_events
    @registrations = Registration.where(:user_id => current_user.id)
  end

end

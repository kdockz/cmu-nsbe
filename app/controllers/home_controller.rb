class HomeController < ApplicationController
  def index
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

end

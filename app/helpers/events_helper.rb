require 'chronic'
module EventsHelper

  def show_date(start_date, end_date)

    if start_date.nil? && end_date.nil? 
      return "TBD"
    elsif start_date.nil? 
      return end_date.strftime("%B %d, %Y") 
    elsif end_date.nil? || start_date == end_date 
      return start_date.strftime("%B %d, %Y" ) 
    else 
      return start_date.strftime("%B %d, %Y" ) + ' - ' + end_date.strftime("%B %d, %Y" ) 
    end

  end

  def show_time(start_time, end_time)

    if (start_time.empty? || start_time.nil?) && (end_time.empty? || end_time.nil?) 
      return "TBD"
    elsif (start_time.empty? || start_time.nil?) 
      return Chronic::parse(end_time).strftime("%l:%M %p")
    elsif (end_time.empty? || end_time.nil?) || start_time == end_time 
      return Chronic::parse(start_time).strftime("%l:%M %p") 
    else 
      return Chronic::parse(start_time).strftime("%l:%M %p") + " - " + Chronic::parse(end_time).strftime("%l:%M %p")
    end

  end
end

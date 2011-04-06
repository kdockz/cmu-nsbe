module AnnouncementsHelper
  
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
  
end

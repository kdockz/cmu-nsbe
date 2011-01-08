module ApplicationHelper
  def show_flash_message(options={})
    html = content_tag(:div, raw(flash.collect{ |name,msg| content_tag(:div, msg, :id => "flash_#{name}") }), :id => 'flash-message')
    if options.key?(:fade)
      html << content_tag(:script, "$(document).ready(function() { 
      $(\'#flash-message\').fadeOut(#{options[:fade]*1000}, function() { 
        // Animation complete. 
        }); 
      });", :type => 'text/javascript')
    end
    html
  end
  
  def check_member_registration(event, user)
    return true if Registration.find(:first, :conditions => ['event_id = ? and user_id = ?', event.id, user.id])
    false
  end
  
  def get_member_registration(event, user)
    return Registration.find(:first, :conditions => ['event_id = ? and user_id = ?', event.id, user.id])
  end
end

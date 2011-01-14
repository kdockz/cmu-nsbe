module ApplicationHelper
  def show_flash_message(options={})
    
    html = raw(content_tag(:div, raw(flash.collect{ |name,msg| content_tag(:div, msg, :id => "flash_#{name}") }.join) , :id => 'flash-message'))

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
    return true if Registration.where('event_id = ? and user_id = ?', event.id, user.id).first
    false
  end
  
  def get_member_registration(event, user)
    return Registration.where('event_id = ? and user_id = ?', event.id, user.id).first
  end
end

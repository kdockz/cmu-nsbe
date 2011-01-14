desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  require 'chronic'
  
 if Time.now.hour % 4 == 0 # run every four hours
   @events = Event.all
   @events.each do |event|
     
      if (event.start_date > Date.today && event.end_date < Date.today)
         event.status = 1
       elsif event.end_date < Date.today
         event.status = 2
         event.registration = false
         
       elsif event.end_date == Date.today
         
         if event.start_time > Time.now && event.end_time < Time.now
           event.status = 1
           event.registration = false
           
         elsif event.start_time < Time.now
           event.status = 0
           
         elsif event.end_time > Time.now
           event.status = 2
           event.registration = false
         end
         
       else
         event.status = 0
       end
       
       event.save!
   end
 end
end

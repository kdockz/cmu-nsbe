class EventsController < ApplicationController
  before_filter :login_required, :except => [:show, :index]
  load_and_authorize_resource
  
  # GET /events
  # GET /events.xml
  def index
    
    # Grab upcoming events only.
    @events = Event.all
    
    #Grab past events.
    @past_events = Event.past
    
    session[:event] = nil

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    
    # Store the current event in a session variable for registration purposes.
    @event = Event.find(params[:id])
    session[:event] = @event
    
    # Find all users registered for a particular event.
    @registered_users = Registration.for_event(@event.id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    # Sets hidden fields when user creates an event.
    # Creator of the event is set to the current user, and the event is set to active.
    @event.user_id = current_user.id
    @event.active = true

    # This condition checks to make sure that all date fields, and time fields are set.
    # Otherwise, a google event will not be created for the event.
    if @event.check_date_and_time
      
      # Authenticate for google session.
      service = GCal4Ruby::Service.new 
      service.authenticate("cmu.nsbe.telecoms", "nsbe2endzone")

      # Grab the appropriate calendar- "Events"
      # cal = GCal4Ruby::Calendar.find(service, {:title => "Events"})      
      cal = service.calendars[1]
    
      # Create the google event, set its fields, and save it.
      gevent = GCal4Ruby::Event.new(service) 
      gevent.calendar = cal
      gevent.title = @event.name
      gevent.start_time = Time.parse("#{@event.start_date} at #{@event.start_time}")
      gevent.end_time = Time.parse("#{@event.end_date} at #{@event.end_time}")
      gevent.where = @event.location
      gevent.save
    end

    respond_to do |format|
      if @event.save!
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])
    
      if @event.check_date_and_time

        # Authenticate for google session.
        service = GCal4Ruby::Service.new 
        service.authenticate("cmu.nsbe.telecoms", "nsbe2endzone")

        # Grab the appropriate calendar- "Events"
        cal = service.calendars[1]

        # Create the google event, set its fields, and save it.
        google_events = GCal4Ruby::Event.find(service, { :calendar => cal.id })

        google_events.reject!{ |e| e.title != @event.name && e.start_time != Time.parse("#{@event.start_date} at #{@event.start_time}") }

        if google_events.empty?
          
            # Create the google event, set its fields, and save it.
            gevent = GCal4Ruby::Event.new(service) 
            gevent.calendar = cal
            gevent.title = @event.name
            gevent.start_time = Time.parse("#{@event.start_date} at #{@event.start_time}")
            gevent.end_time = Time.parse("#{@event.end_date} at #{@event.end_time}")
            gevent.where = @event.location
            gevent.save
            
        else
          
          google_events.each do |e|
              e.title = @event.name
              e.start_time = Time.parse("#{@event.start_date} at #{@event.start_time}")
              e.end_time = Time.parse("#{@event.end_date} at #{@event.end_time}")
              e.where = @event.location
              e.save!
          end
        end
      end
      

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    
    if @event.check_date_and_time

      # Authenticate for google session.
      service = GCal4Ruby::Service.new 
      service.authenticate("cmu.nsbe.telecoms", "nsbe2endzone")

      # Grab the appropriate calendar- "Events"
      # cal = GCal4Ruby::Calendar.find(service, {:title => "Events"})      
      cal = service.calendars[1]

      # Create the google event, set its fields, and save it.
      google_events = GCal4Ruby::Event.find(service, { :calendar => cal.id })
      
      google_events.reject!{ |e| e.title != @event.name && e.start_time != Time.parse("#{@event.start_date} at #{@event.start_time}") }
      
      google_events.each do |e|
          e.delete
      end
    end
    
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
end

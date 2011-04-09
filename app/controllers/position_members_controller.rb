class PositionMembersController < ApplicationController
  # GET /position_members
  # GET /position_members.xml
  def index
    @position_members = PositionMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @position_members }
    end
  end

  # GET /position_members/1
  # GET /position_members/1.xml
  def show
    @position_member = PositionMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @position_member }
    end
  end

  # GET /position_members/new
  # GET /position_members/new.xml
  def new
    @position_member = PositionMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @position_member }
    end
  end

  # GET /position_members/1/edit
  def edit
    @position_member = PositionMember.find(params[:id])
  end
  
  def new_executive_board
    @eboard_positions = Position.eboard
  end
  def modify_executive_board
    @vacant_positions=Position.current.all
    @positions= @vacant_positions.dup
    for position in @positions
      past_officers = PositionMember.by_position(position.id)
      if !past_officers.nil? || !past_officers.empty?
        past_officers.each do |officer|  
          if officer.active == true
            @vacant_positions.delete(position)
            break
          end
        end
      end
    end
    @eboard = PositionMember.eboard
  end
  def save_executive_board
    current_eboard = PositionMember.eboard.all
    
    # Creates an executive board member, if a user_id is specified.
    for member in params[:eboard]
      unless member[:user_id].nil? || member[:user_id].empty?
        current_officeholder = PositionMember.eboard.where(:position_id => member[:position_id])[0]
        unless current_officeholder.nil?
          current_officeholder.active = false
          current_officeholder.save!
          current_eboard.delete(current_officeholder)
        end      
        @pm = PositionMember.new
        @pm.position_id = member[:position_id]
        @pm.user_id = member[:user_id]
        @pm.active = true
        @pm.save
      end
      
      for old_member in current_eboard 
        old_member.active = false
        old_member.save!
      end
    end
    
    redirect_to administration_path
  end
  
  def update_executive_board
    
    #Modifies an existing executive board member.
    for member in params[:eboard]
      @pm = PositionMember.find(member[0])
      unless @pm.nil?
        @pm.user_id = member[1][:user_id]
        @pm.save!
      end
      
    end
    
    # Creates an executive board member, if a user_id is specified.
    for member in params[:new_eboard]
      unless member[:user_id].nil? || member[:user_id].empty?
        @pm = PositionMember.new
        @pm.position_id = member[:position_id]
        @pm.user_id = member[:user_id]
        @pm.active = true
        @pm.save
      end
    end
    
    redirect_to administration_path
  end

  # POST /position_members
  # POST /position_members.xml
  def create
    @position_member = PositionMember.new(params[:position_member])

    respond_to do |format|
      if @position_member.save
        @user = User.find(@position_member.user_id)
        @user.access_level = 30
        @user.save!
        format.html { redirect_to(@position_member, :notice => 'Position member was successfully created.') }
        format.xml  { render :xml => @position_member, :status => :created, :location => @position_member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @position_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /position_members/1
  # PUT /position_members/1.xml
  def update
    @position_member = PositionMember.find(params[:id])

    respond_to do |format|
      if @position_member.update_attributes(params[:position_member])
        format.html { redirect_to(@position_member, :notice => 'Position member was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @position_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /position_members/1
  # DELETE /position_members/1.xml
  def destroy
    @position_member = PositionMember.find(params[:id])
    @position_member.destroy

    respond_to do |format|
      format.html { redirect_to(position_members_url) }
      format.xml  { head :ok }
    end
  end
end

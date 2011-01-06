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

  # POST /position_members
  # POST /position_members.xml
  def create
    @position_member = PositionMember.new(params[:position_member])

    respond_to do |format|
      if @position_member.save
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

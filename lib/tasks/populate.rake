namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    # Need two gems to make this work: faker & populator
    # Docs at: http://populator.rubyforge.org/
    require 'populator'
    # Docs at: http://faker.rubyforge.org/rdoc/
    require 'faker'

    # Step 0: clear any old data in the db
    [Event, User, Position, PositionMember, Zone, Announcement, Registration].each(&:delete_all)

    # Step 1: Setup zones.
    # Read the zone file and store it in an array.
    zones = Array.new  
    zones_file = File.open("#{RAILS_ROOT}/lib/tasks/zones.txt")
    zones_file.each_line { |line| zones << line.chomp }

    # Create all the Zones.
    zones.each do |zone|
      z = Zone.new
      z.name = zone
      z.save!
    end

    # Step 2: Setup positions
    # Read the positions file and store it in an array.
    positions = Array.new  
    positions_file = File.open("#{RAILS_ROOT}/lib/tasks/positions.txt")
    positions_file.each_line { |line| positions << line.chomp }

    # Create all the Positions.
    positions.each do |position| 
      # split the family record by the commas
      pos = position.split(':')
      p = Position.new
      p.name = pos[0]
      zone = Zone.find(:first, :conditions => ['name = ?', pos[1]])
      p.zone_id = zone.id
      p.email = pos[2]
      p.save!
    end

    # Step 3: Setup users and create their positions as members.
    # Read the positions file and store it in an array.
    users = Array.new  
    users_file = File.open("#{RAILS_ROOT}/lib/tasks/users.txt")
    users_file.each_line { |line| users << line.chomp }

    # Create all the Positions.
    users.each do |user| 

      # split the member information by colons.
      member = user.split(':')

      #Create the member
      m = User.new
      m.first_name = member[0]
      m.last_name = member[1]
      m.email = member[2]
      m.major = member[3]
      m.class_level = member[4]
      if (member.size == 8)
        m.photo = File.open("#{RAILS_ROOT}/public/temp/officers/#{member[7]}")
      end
      m.active = true
      username = member[2].split('@')
      m.login = username[0]
      m.password = "secret"
      m.password_confirmation = "secret"
      m.access_level = member[6]
      m.save!

      #Create them in the position
      pm = PositionMember.new
      position = Position.find(:first, :conditions => ['name = ?', member[5]])
      pm.position_id =  position.id
      pm.user_id = m.id
      pm.active = true
      pm.save!

    end


  end
end
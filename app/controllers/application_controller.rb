require 'lib/authenticated_system.rb'
class ApplicationController < ActionController::Base
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  protect_from_forgery
  
  
end

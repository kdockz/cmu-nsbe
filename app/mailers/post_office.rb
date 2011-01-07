class PostOffice < ActionMailer::Base
  default :from => "system@cmu-nsbe.heroku.com"

  def welcome_email(user)
    @user = user
    mail(:to => user.email,
    :subject => "Welcome to the CMU NSBE Community!")
  end

end

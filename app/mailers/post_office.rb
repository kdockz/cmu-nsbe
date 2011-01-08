class PostOffice < ActionMailer::Base
  default :from => "cmu.nsbe.system@gmail.com"

  def welcome_email(user)
    @user = user
    mail(:to => user.email,
    :subject => "Welcome to the CMU NSBE Community!")
  end
  def reset_password_email(user, password)
    @user = user
    @password = password
    mail(:to => user.email,
    :subject => "Your Password has been reset.")
  end

end

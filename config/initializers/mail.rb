Nsbe::Application.config.action_mailer.perform_deliveries = true
Nsbe::Application.config.action_mailer.raise_delivery_errors = true
Nsbe::Application.config.action_mailer.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "cmu-nsbe.heroku.com",
  :user_name            => "cmu.nsbe.system",
  :password             => "end2zone",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
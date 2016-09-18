class ApplicationMailer < ActionMailer::Base
  default Settings.email_defaults.to_hash
  layout 'mailer'
end

class NotificationMailer < ApplicationMailer

  def failed_email(site, check)
    @site  = site
    @check = check
    mail(to: site.notification_email, subject: "Tenken alert: Check FAILED for #{site.uri}")
  end

  def restored_email(site, check)
    @site  = site
    @check = check
    mail(to: site.notification_email, subject: "Tenken alert: Check PASSED for #{site.uri}")
  end
end

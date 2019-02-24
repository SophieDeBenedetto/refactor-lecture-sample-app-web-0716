class UserMailer < ApplicationMailer
  FROM = ENV['EMAIL_ADDRESS']
  def issue_update_email(user, issue)
    @user = user
    @issue = issue
    mail(to: @user.email, from: FROM, subject: 'an issue has been updated on GitHub')
  end
end

class MentionMailer < ActionMailer::Base
  layout 'mailer'
  default from: Setting.mail_from

  helper :application
  include ApplicationHelper

  def self.default_url_options
    Mailer.default_url_options
  end
  
  
  def notify_mentioning(issue, journal, user)
    @issue = issue
    @journal = journal
    Mention.where(issue_id: issue.id).where(user_id: user.id).first_or_create
    mail(to: user.mail, subject: "[#{@issue.tracker.name} ##{@issue.id}] You were mentioned in: #{@issue.subject}")
  end
end

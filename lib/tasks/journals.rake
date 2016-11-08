namespace :redmine do
  task :mention_journal => :environment do
    Journal.all.each do |journal|
      if journal.journalized.is_a?(Issue) && journal.notes.present?
        issue = journal.journalized
        project= journal.journalized.project
        users=project.users.to_a.delete_if{|u| (u.type != 'User' || u.mail.empty?)}
        users_regex=users.collect{|u| "#{Setting.plugin_redmine_mentions['trigger']}#{u.login}"}.join('|')
        regex_for_email = '\B('+users_regex+')\b'
        regex = Regexp.new(regex_for_email)
        mentioned_users = journal.notes.scan(regex)
        mentioned_users.each do |mentioned_user|
          username = mentioned_user.first[1..-1]
          if user = User.find_by_login(username)
            Mention.where(issue_id: issue.id).where(user_id: user.id).first_or_create
          end
        end
      end
    end
  end
end

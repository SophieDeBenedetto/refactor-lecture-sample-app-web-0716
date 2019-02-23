class GithubAdapter
  def self.get_issues_for(repo)
    client.issues("#{repo.user.github_username}/#{repo.name}").each do |issue|
      Issue.create(url: issue.html_url, opened_by: issue.user.login, status: issue.state, title: issue.title, content: issue.body, opened_on: issue.created_at, assignee: issue.assignee, repository: repo)
    end
  end

  def self.create_webhook_for(repo)
    client.create_hook("#{repo.owner}/#{repo.user.github_username}",
      'web',
      {url: "#{ENV['ISSUE_TRACKR_APP_URL']}/webhooks/receive", content_type: 'json'},
      {events: ['issues'], active: true})
  end

  def self.client
    @@client ||= Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
  end
end

class GithubAdapter
  # know what the GH client is
  # know how to get a repo's issues
  # know how to create a webhook on a repo

  def self.get_issues_for(repo)
    client.issues("#{repo.user.github_username}/#{repo.name}").each do |issue|
      Issue.create(url: issue.html_url, opened_by: issue.user.login, status: issue.state, title: issue.title, content: issue.body, opened_on: issue.created_at, assignee: issue.assignee, repository: repo)
    end
  end

  def self.create_webhook_for(repo)
    client.client.create_hook("#{repo.owner}/#{repo.user.github_username}",
      'web',
      {url: "#{ENV['ISSUE_TRACKR_APP_URL']}/webhooks/receive", content_type: 'json'},
      {events: ['issues'], active: true})
  end

  def self.client
    @@client ||= Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
  end
end

#@client ||= Octokit::Client.new(access_token: ENV["GITHUB_TOK
# Makes a GET request to the github api to get the issues of a given repo
# @client.issues("#{repo_owner}/#{repo_name}").each do |issue|
#   Issue.create(url: issue.html_url, opened_by: issue.user.login, status: issue.state, title: issue.title, content: issue.body, opened_on: issue.created_at, assignee: issue.assignee, repository: @repo)
# end
# @client.create_hook("#{repo_owner}/#{repo_name}",
#   'web',
#   {url: "#{ENV['ISSUE_TRACKR_APP_URL']}/webhooks/receive", content_type: 'json'},
#   {events: ['issues'], active: true})

module Adapter
  class GitHubWrapper
    attr_accessor :client

    def initialize
      @client ||= Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
    end

    def get_and_save_repo_issues(repo)
      client.issues("#{repo.user.github_username}/#{repo.name}").each do |issue|
        Issue.create(url: issue.html_url, opened_by: issue.user.login, status: issue.state, title: issue.title, content: issue.body, opened_on: issue.created_at, assignee: issue.assignee, repository: repo)
      end
    end

    def add_webhook_to_repo(repo)
      client.create_hook("#{repo.user.github_username}/#{repo.name}",
        'web',
        {url: "#{ENV['ISSUE_TRACKR_APP_URL']}/webhooks/receive", content_type: 'json'},
        {events: ['issues'], active: true})
    end
  end

  # class TwilioApiWrapper
  # end


end


# client = Adapter::GitHubWrapper.new(ENV["GITHUB_TOKEN"])
#       client.get_and_save_repo_issues(@repo)
#       client.add_webhook_to_repo(@repo)
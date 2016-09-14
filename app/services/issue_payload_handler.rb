class IssuePayloadHandler

  def self.execute(issue_params)
    @issue = Issue.find_or_create_by(url: issue_params["html_url"])
    update_from_params(issue_params)
    @issue
    # find or create the issue
    # get the issue's repository, if it is a NEW issue
    # update the found or created issue with the info from params
  end

  def self.update_from_params(issue_params)
    update_issue_repo_from_params(issue_params)
    @issue.update(title: issue_params["title"], content: issue_params["body"], assignee: issue_params["assignee"], status: issue_params["state"])
  end

  def self.update_issue_repo_from_params(issue_params)
    if !@issue.repository
      url_elements= issue_params["repository_url"].split("/")
      repo_url = "https://github.com/#{url_elements[-2]}/#{url_elements[-1]}"
      repo = Repository.find_by(url: repo_url)
      @issue.update(repository: repo)
    end
  end
end


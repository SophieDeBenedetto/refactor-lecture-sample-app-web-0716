class RepoGenerator
  def self.create_repo(repo_params, current_user)
    repo_owner = repo_params[:url].split("/")[-2]
    repo_name = repo_params[:url].split("/")[-1]
    Repository.new(name: repo_name, url: repo_params[:url], user: current_user)
  end
end
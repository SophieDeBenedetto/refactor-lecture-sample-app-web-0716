class RepositoryCreationService
  def self.execute(params, user)
    new(params, user).execute
  end

  attr_reader :repo_owner, :repo_name, :url, :user
  def initialize(params, user)
    @user       = user
    @repo_owner = repo_owner_from_params(params)
    @repo_name  = repo_name_from_params(params)
    @url        = params[:repository][:url]
  end

  def execute
    Repository.new(name: repo_name, url: url, user: user)
  end

  private

  def repo_owner_from_params(params)
    params[:repository][:url].split("/")[-2]
  end

  def repo_name_from_params(params)
    params[:repository][:url].split("/")[-1]
  end
end

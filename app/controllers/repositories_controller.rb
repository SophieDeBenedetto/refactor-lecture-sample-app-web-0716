class RepositoriesController < ApplicationController

  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = Repository.find(params[:id])
    if @repository.user == current_user
      render :show
    else
      redirect_to root_path, notice: "you can only view your own repos!"
    end
  end

  def create
    # def get_repo_name_from_url(params)
    #   @repo_name= params[:repository][:url].split("/")[-1]
    # end
    #
    # def get_repo_owner_from_url(params)
    #   params[:repository][:url].split("/")[-2]
    # end
    #
    # Repo.create(name: repo_name)
    # repo_owner = params[:repository][:url].split("/")[-2]
    # repo_name = params[:repository][:url].split("/")[-1]
    # @repo = Repository.new(name: repo_name, url: params[:repository][:url], user: current_user)
    @repo = RepositoryCreationService.create_repo(params)
    if @repo.save
      GithubAdapter.get_issues_for(@repo)
      GithubAdapter.create_webhook_for(@repo)
    end
    respond_to do |f|
      f.js
      f.html {head :no_content; return}
    end
  end
end

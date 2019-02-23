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
    @repo = RepositoryCreationService.execute(params, current_user)
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

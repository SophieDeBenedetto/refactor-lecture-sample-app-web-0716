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
    repo = RepoGenerator.create_repo(repo_params, current_user)
    if repo.save
      client = Adapter::GitHubWrapper.new
      client.get_and_save_repo_issues(repo)
      client.add_webhook_to_repo(repo)
    end
    respond_to do |f|
      f.js
      f.html {head :no_content; return}
    end
  end

  private
      def repo_params
        params.require(:repository).permit(:url)
      end
end


require 'rails_helper'
require 'ostruct'

RSpec.describe RepositoriesController, :type => :controller do

  let(:user) { User.create(name: "Sophie DeBenedetto", email: "sophie.debenedetto@gmail.com", github_username: "sophiedebenedetto") }
  let(:client1) { double('client') }
  let(:client2) { double('client') }
  let(:repo_issue1) { OpenStruct.new(html_url: "www.github.com/user/repo/issues/40", user: OpenStruct.new(login: "sophie"), state: "open", title: "Issue With A Thing", content: "blah blah", opened_on: Date.today)}
  let(:repo_issue2) { OpenStruct.new(html_url: "www.github.com/user/repo/issues/40", user: OpenStruct.new(login: "sophie"), state: "open", title: "Issue With A Different Thing", content: "yadda yadda", opened_on: Date.yesterday) }
  let(:issues) { [repo_issue1, repo_issue2] }
   before(:each) do
    allow(controller).to receive(:logged_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
   end
  describe "#create" do
    # before do
    #   allow(Octokit::Client).to receive(:new).and_return(client)
    #   allow(client).to receive(:issues).and_return(issues)
    #   allow(client).to receive(:create_hook)
    # end

    xit "creates a repo with the given link and information requested from github" do
      allow(Octokit::Client).to receive(:new).and_return(client1)
      allow(client1).to receive(:issues).and_return(issues)
      allow(client1).to receive(:create_hook)
      expect do
        post :create, params: {repository: {url: "https://github.com/sophiedebenedetto/learn-write"}}
      end.to change {Repository.count}.from(0).to(1)
      repo = Repository.first
      expect(repo.url).to eq("https://github.com/sophiedebenedetto/learn-write")
      expect(repo.name).to eq("learn-write")
    end

    it "creates the correct number of issues and associates them to the new repository" do
      allow(Octokit::Client).to receive(:new).and_return(client2)
      allow(client2).to receive(:issues).and_return(issues)
      allow(client2).to receive(:create_hook)
       post :create, params: {repository: {url: "https://github.com/sophiedebenedetto/learn-write"}}
       repo = Repository.first
       expect(repo.issues.count).to eq(2)
       expect(Issue.first.repository).to eq(repo)
       expect(Issue.second.repository).to eq(repo)
    end
  end
end

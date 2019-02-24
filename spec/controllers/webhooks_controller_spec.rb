require 'rails_helper'

RSpec.describe WebhooksController, :type => :controller do
  include SmsSpec::Helpers
  FIXTURES_PATH = Rails.root.join("spec", "fixtures")


  describe "#receive" do
    let(:twilio_messages_client) { double('messages_client', {create: true})}
    let(:twilio_client)          { double('client', {messages: twilio_messages_client})}
    let(:payload)  {  JSON.parse(File.read("#{FIXTURES_PATH }/webhook_issue_payload.json"), symbolize_names: true) }
    let!(:user)    {  User.create(name: "Sophie DeBenedetto", email: "sophie.debenedettogmail.com", github_username: "SophieDeBenedetto", phone_number: "123-456-7890") }
    let!(:repo)    {  Repository.create(name: "learn-write", url: "https://github.com/SophieDeBenedetto/learn-write", user: user) }

    before(:each) do
      allow(Twilio::REST::Client).to receive(:new).and_return(twilio_client)
    end

    context "with a new issue" do
      it "creates a new issue with the info in the payload from github" do
        post :receive, payload
        issue = Issue.first
        expect(repo.issues.count).to eq(1)
        expect(issue.url).to eq("https://github.com/SophieDeBenedetto/learn-write/issues/5")
        expect(issue.repository).to eq(repo)
        expect(issue.user).to eq(user)
      end
    end

    context "updating an existing issue" do
      it "updates an existing issue with the info in the payload from github" do
        repo.issues.build(url: "https://github.com/SophieDeBenedetto/learn-write/issues/5", content: "testing")
        post :receive, payload
        expect(repo.issues.count).to eq(1)
        expect(repo.issues.first.content).to eq("THIS IS a TEST")
      end
    end

    context "notifications" do
      it "sends an email update to the user whose issue has been created/updated" do
        post :receive, payload
        email = ActionMailer::Base.deliveries.last
        expect(ActionMailer::Base.deliveries.length).to eq(1)
        expect(email.from).to eq(["ghissue.trackrgmail.com"])
        expect(email.to).to eq(["sophie.debenedettogmail.com"])
        expect(email.subject).to eq("an issue has been updated on GitHub")
      end

      it "sends a text message to the use whose issue has been created/updated" do
        post :receive, payload
        text_message = open_last_text_message_for(user.phone_number)
        expect(text_message.body).to eq("test issue 2 has been updated. View it here: https://github.com/SophieDeBenedetto/learn-write/issues/5")
        expect(text_message.from).to eq("+1 914-363-0827")
        expect(text_message.number).to eq("234567890")
      end
    end
  end
end

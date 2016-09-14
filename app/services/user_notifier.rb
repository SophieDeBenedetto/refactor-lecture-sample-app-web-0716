class UserNotifier

  def self.execute(issue)
    send_text(issue)
    send_email(issue)
  end

  def self.send_text(issue)
    owner = issue.repository.user
     if owner.phone_number
      # client = Adapter::TwilioApiWrapper.new
      # client.send_text
        @client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])
        @client.messages.create(
          to: owner.phone_number, 
          from: "+1 #{ENV['TWILIO_NUMBER']}",
           body: "#{issue.title} has been updated. View it here: #{issue.url}")
      end
  end

  def self.send_email(issue)
    UserMailer.issue_update_email(issue.user, issue).deliver_now
  end
end

# owner = issue.repository.user
      # if owner.phone_number
      #   @client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])
      #   @client.messages.create(
      #     to: owner.phone_number, 
      #     from: "+1 #{ENV['TWILIO_NUMBER']}",
      #      body: "#{issue.title} has been updated. View it here: #{issue.url}")
      # end
      # UserMailer.issue_update_email(issue.user, issue).deliver_now
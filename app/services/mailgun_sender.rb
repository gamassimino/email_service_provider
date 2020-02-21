class MailgunSender

  # Requirements for make POST to different email service provider
  require 'rest-client'

  # Initialize all variables necesary for work then when call send method
  def initialize(params)
    @params = params
    @errors = []
  end

  # Send POST to MailgGun API with JSON data comes from /api/v1/email
  def send
    begin
      response = RestClient.post "https://api:#{ENV['MG_API_KEY']}"\
      "@api.mailgun.net/v3/#{ENV['MG_DOMAIN']}/messages",
      from: "#{@params['from_name']} <#{@params['from']}>",
      to: "#{@params['to_name']}, #{@params['to']}",
      subject: "#{@params['subject']}",
      html: "#{ActionController::Base.helpers.sanitize(@params["body"])}"
    rescue RestClient::ExceptionWithResponse => e
      @errors = e.response
    end
  end

  # Get errors array from outside this service
  def errors
    @errors
  end
end
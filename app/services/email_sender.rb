class EmailSender
  # Requirements for make POST to different email service provider
  require 'rest-client'
  require 'sendgrid-ruby'
  include SendGrid

  # Initialize all variables necesary for work then when call send method
  def initialize(params)
    @params = params
    @service = ENV['EMAIL_SERVICE']
    @errors = []
  end

  # Deliver responsability of send to the correct email service provider
  def send
    if valid_input?
      @service == 'SENDGRID' ? send_with_sendgrid : send_with_mailgun
    end
  end

  # Send POST to Sendgrid API with JSON data comes from /api/v1/email
  def send_with_sendgrid
    data = JSON.parse(%Q({
      "personalizations": [
        {
          "to": [
            {
              "name": "#{@params["to_name"]}",
              "email": "#{@params["to"]}"
            }
          ],
          "subject": "#{@params["subject"]}"
        }
      ],
      "from": {
        "name": "#{@params["from_name"]}",
        "email": "#{@params["from"]}"
      },
      "content": [
        {
          "type": "text/html",
          "value": "#{@params["body"]}"
        }
      ]
    }))

    sendgrid = SendGrid::API.new(api_key: ENV['SG_API_KEY'])
    response = sendgrid.client.mail._("send").post(request_body: data)
  end

  # Send POST to MailgGun API with JSON data comes from /api/v1/email
  def send_with_mailgun
    RestClient.post "https://api:#{ENV['MG_API_KEY']}"\
    "@api.mailgun.net/v3/#{ENV['MG_DOMAIN']}/messages",
    from: "#{@params['from_name']} <#{@params['from']}>",
    to: "#{@params['to_name']}, #{@params['to']}",
    subject: "#{@params['subject']}",
    html: "#{@params['body']}"
  end

  # Get errors array from outside this service
  def errors
    @errors
  end

  private

  # Filter parameter to avoid loop in larger collections and be sure we are
  # looking and comparing just for six element
  def permited_params
    @params.permit(:to, :to_name, :from, :from_name, :subject, :body)
  end

  # Validations
  # all fields are required
  # any input should be blank
  def valid_input?
    size = 1
    permited_params.keys.each do |key|
      @errors << "#{permited_params[key]} is blank" if permited_params[key].empty?
      size += 1
    end
    @errors << 'to, to_name, from, from_name, subject, body params are required' if size == 6

    return @errors.blank?
  end
end
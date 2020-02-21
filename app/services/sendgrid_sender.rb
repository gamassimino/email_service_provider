class SendgridSender
  # Requirements for make POST to different email service provider
  require 'sendgrid-ruby'
  include SendGrid

  # Initialize all variables necesary for work then when call send method
  def initialize(params)
    @params = params
    @errors = []
  end

  # Send POST to Sendgrid API with JSON data comes from /api/v1/email
  def send
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
          "value": "#{ActionController::Base.helpers.sanitize(@params["body"])}"
        }
      ]
    }))

    sendgrid = SendGrid::API.new(api_key: ENV['SG_API_KEY'])
    response = sendgrid.client.mail._("send").post(request_body: data)

    @errors = JSON.parse(response.body)['errors'] unless ['200','201','202'].include? response.status_code
  end

  # Get errors array from outside this service
  def errors
    @errors
  end
end
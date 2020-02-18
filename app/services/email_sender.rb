class EmailSender
  require 'rest-client'
  require 'sendgrid-ruby'
  include SendGrid

  def initialize(params)
    @params = params
    @service = ENV['EMAIL_SERVICE']
    @errors = []
  end

  def send
    if valid_input?
      @service == 'SENDGRID' ? send_with_sendgrid : send_with_mailgun
    end
  end

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

  def send_with_mailgun
    RestClient.post "https://api:#{ENV['MAILGUN_API_KEY']}"\
    "@api.mailgun.net/v3/sandbox5ce6b250d3cb4c30842193a67a4139d3.mailgun.org/messages",
    from: "#{@params['from_name']} <#{@params['from']}>",
    to: "#{@params['to_name']} <#{@params['to']}>",
    subject: "#{@params['subject']}",
    html: "#{@params['body']}"
  end

  def errors
    @errors
  end

  private
  def permited_params
    @params.permit(:to, :to_name, :from, :from_name, :subject, :body)
  end

  def valid_input?
    size = 0
    permited_params.keys.each_with_index do |key, index|
      @errors << "#{permited_params[key]} is blank" if permited_params[key].empty?
      size = index
    end
    @errors << 'to, to_name, from, from_name, subject, body params are required' if size != 5

    return @errors.blank?
  end
end
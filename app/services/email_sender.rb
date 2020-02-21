class EmailSender
  require 'json'

  # Initialize all variables necesary for work then when call send method
  def initialize(params)
    @params = params
    @service = ENV['EMAIL_SERVICE'].constantize.new(@params)
    @errors = []
  end

  # Deliver responsability of send to the correct email service provider
  def send
    if valid_input?
      @service.send
      @errors = @service.errors if @service.errors.present?
    end
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

  # Regex to check if email is valid
  def valid_email?(email)
    email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end

  # Validations
  # all fields are required
  # to & from inputs shoul be valid emails
  # any input should be blank
  def valid_input?
    size = 1
    permited_params.keys.each do |key|
      @errors << "#{permited_params[key]} is blank" if permited_params[key].empty?
      size += 1
    end
    @errors << 'to, to_name, from, from_name, subject, body params are required' if size == 6
    @errors << 'to is not a valid email' unless valid_email?(permited_params['to'])
    @errors << 'from is not a valid email' unless valid_email?(permited_params['from'])

    return @errors.blank?
  end
end
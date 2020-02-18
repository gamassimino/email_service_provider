class Api::V1::EmailsController < ApplicationController

  def send_email
    email_sender = EmailSender.new(params)
    email_sender.send
    if email_sender.errors.blank?
      render json: "your email was sent correctly", status: :ok
    else
      render json: email_sender.errors, status: :bad_request
    end
  end
end

require 'rails_helper'

RSpec.describe 'Status requests' do
  describe 'POST /api/v1/email with arguments' do
    it 'return a status ok' do
      post '/api/v1/email', params: {
        to: "youremail@yourdomain.com",
        to_name: "Mr. Fake",
        from: "noreply@mybrightwheel.com",
        from_name: "Brightwheel",
        subject: "A Message from Brighwheet",
        body: "<h1>Your Bill</h><p>$10</p>"
      }

      expect(response.status).to eq(200)
    end
  end

  describe 'POST /api/v1/email without full arguments' do
    it 'return a status bad request with any arguments' do
      post '/api/v1/email'

      expect(response.status).to eq(400)
    end

    it 'return a status bad request with some arguments' do
      post '/api/v1/email', params: {
        to: "youremail@yourdomain.com",
        from: "noreply@mybrightwheel.com",
        subject: "A Message from Brighwheet",
        body: "<h1>Your Bill</h><p>$10</p>"
      }

      expect(response.status).to eq(400)
    end
  end
end
require 'rails_helper'

RSpec.describe '/animes', type: :request do
  describe 'GET /' do
    it "works! (now write some real specs)" do
      get animes_path
      expect(response).to have_http_status(200)
    end
  end
end

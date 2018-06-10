require 'rails_helper'

RSpec.describe '/users', type: :request do
  describe 'GET /' do
    context 'for a visitor' do
      before do
        create_list(:user, 5)
        get users_path
      end
      it 'should respond with correct attributes' do
        expect(data).to have_jsonapi_attributes([:name, :username])
      end
    end

    context 'for an owner' do
      before do
        user = create(:user)
        token = create(:access_token, resource_owner: user)
        get users_path, headers: auth_header(token)
      end
      it 'should respond with correct attributes' do
        expect(data).to have_jsonapi_attributes([:name, :username, :email])
      end
    end
  end

  describe 'GET /:id' do
    context 'for a visitor' do
      before do
        user = create(:user)
        get user_path(user)
      end
      it 'should respond with correct attributes' do
        expect(data).to have_jsonapi_attributes([:name, :username])
      end
    end

    context 'for an owner' do
      before do
        user = create(:user)
        token = create(:access_token, resource_owner: user)
        get user_path(user), headers: auth_header(token)
      end
      it 'should respond with correct attributes' do
        expect(data).to have_jsonapi_attributes([:name, :username, :email])
      end
    end
  end
end

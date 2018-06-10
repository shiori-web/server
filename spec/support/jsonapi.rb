module JSONAPITestHelper
  def json
    JSON.parse(response.body)
  end

  def data
    json['data']
  end

  def token(user)
    create(:access_token, resource_owner: user)
  end

  def auth_header(token)
    { 'Authorization' => "Bearer #{token.token}" }
  end
end

RSpec::Matchers.define :have_jsonapi_attributes do |expected|
  match do |actual|
    expected = expected.map(&:to_sym).sort
    actual = actual.is_a?(Array) ? actual : [actual]
    actual.all? { |item| item['attributes'].keys.map(&:to_sym).sort == expected }
  end
end

RSpec.configure do |config|
  config.include JSONAPITestHelper, type: :request
end

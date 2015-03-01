require 'lifx/http'
require 'pry'

RSpec.describe LIFX::HTTP::Client do
  it 'gets lights' do
    client = LIFX::HTTP::Client.new(access_token: '')
    response = client.get_lights

    expect(response).to be_success
  end
end

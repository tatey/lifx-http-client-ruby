require 'lifx/http'
require 'pry'

RSpec.describe LIFX::HTTP::Client do
  let(:client) { LIFX::HTTP::Client.new(access_token: '') }

  it 'gets lights' do
    response = client.get_lights

    expect(response).to be_success
  end

  it 'posts toggle' do
    response = client.post_toggle(selector: 'all', state: 'on')

    expect(response).to be_success
  end
end

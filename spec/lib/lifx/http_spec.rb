require 'lifx/http'
require 'pry'

RSpec.describe LIFX::HTTP::Client do
  let(:client) { LIFX::HTTP::Client.new(access_token: '') }

  it 'gets lights' do
    response = client.get_lights

    expect(response).to be_success
  end

  it 'puts power' do
    response = client.put_power(selector: 'all', state: 'off')

    expect(response).to be_success
  end

  it 'posts toggle' do
    response = client.post_toggle(selector: 'all')

    expect(response).to be_success
  end

  it 'puts color' do
    response = client.put_lights_color(selector: 'all', color: 'blue')

    expect(response).to be_success
  end

  it 'posts breathe' do
    response = client.post_lights_effect_breathe(selector: 'all', color: 'blue')

    expect(response).to be_success
  end

  it 'posts pulse' do
    response = client.post_lights_effect_pulse(selector: 'all', color: 'blue')

    expect(response).to be_success
  end
end

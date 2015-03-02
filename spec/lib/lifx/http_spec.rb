require 'support/vcr'
require 'lifx/http'
require 'pry'

RSpec.describe LIFX::HTTP::Client do
  let(:client) { LIFX::HTTP::Client.new(access_token: 'c72e2adc43df5aafed4f3f95df724f64f224539fc67ca39b2f71169f5fdf8c4f') }

  it 'gets lights' do
    VCR.use_cassette('lights') do
      response = client.get_lights

      expect(response).to be_success
    end
  end

  it 'puts power' do
    VCR.use_cassette('power') do
      response = client.put_power(selector: 'all', state: 'off')

      expect(response).to be_success
    end
  end

  it 'posts toggle' do
    VCR.use_cassette('toggle') do
      response = client.post_toggle(selector: 'all')

      expect(response).to be_success
    end
  end

  it 'puts color' do
    VCR.use_cassette('color') do
      response = client.put_lights_color(selector: 'all', color: 'blue')

      expect(response).to be_success
    end
  end

  it 'posts breathe' do
    VCR.use_cassette('breathe') do
      response = client.post_lights_effect_breathe(selector: 'all', color: 'blue')

      expect(response).to be_success
    end
  end

  it 'posts pulse' do
    VCR.use_cassette('pulse') do
      response = client.post_lights_effect_pulse(selector: 'all', color: 'blue')

      expect(response).to be_success
    end
  end
end

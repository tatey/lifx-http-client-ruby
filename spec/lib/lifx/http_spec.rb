require 'support/vcr'
require 'lifx/http'
require 'pry'

RSpec.describe LIFX::HTTP::Client do
  let(:client) { LIFX::HTTP::Client.new(access_token: 'c72e2adc43df5aafed4f3f95df724f64f224539fc67ca39b2f71169f5fdf8c4f') }

  it 'gets lights' do
    VCR.use_cassette('lights') do
      response = client.lights

      expect(response).to be_success
      expect(response.object.count).to eq(2)
      expect(response.object.first).to eq(LIFX::HTTP::Loader::Device.new(
        'id' => 'd073d5017100',
        'uuid' => '02780349-7558-4842-84bb-8a98778eefd5',
        'label' => 'Bright 1',
        'connected' => true,
        'power' => 'off',
        'color' => {
          'hue' => 249.9977111467155,
          'saturation' => 1.0,
          'kelvin' => 3500
        },
        'brightness' => 0.0,
        'group' => {
          'id' => '1c8de82b81f445e7cfaafae49b259c71',
          'name' => 'Test Group'
        },
        'location' => {
          'id' => '1d6fe8ef0fde4c6d77b0012dc736662c',
          'name' => 'Test Location'
        },
        'last_seen' => '2015-03-02T08:53:02.867+00:00',
        'seconds_since_seen' => 0.002869418
      ))
    end
  end

  it 'puts power' do
    VCR.use_cassette('power') do
      response = client.set_lights_power(selector: 'all', state: 'off')

      expect(response).to be_success
      expect(response.object.count).to eq(2)
      expect(response.object.first).to eq(LIFX::HTTP::Loader::Result.new(
        'id' => 'd073d5017100',
        'label' => 'Bright 1',
        'status' => 'ok'
      ))
    end
  end

  it 'posts toggle' do
    VCR.use_cassette('toggle') do
      response = client.set_lights_toggle(selector: 'all')

      expect(response).to be_success
      expect(response.object.count).to eq(2)
      expect(response.object.first).to eq(LIFX::HTTP::Loader::Result.new(
        'id' => 'd073d5017100',
        'label' => 'Bright 1',
        'status' => 'ok'
      ))
    end
  end

  it 'puts color' do
    VCR.use_cassette('color') do
      response = client.set_lights_color(selector: 'all', color: 'blue')

      expect(response).to be_success
      expect(response.object.count).to eq(2)
      expect(response.object.first).to eq(LIFX::HTTP::Loader::Result.new(
        'id' => 'd073d5017100',
        'label' => 'Bright 1',
        'status' => 'ok'
      ))
    end
  end

  it 'posts breathe' do
    VCR.use_cassette('breathe') do
      response = client.run_lights_breathe_effect(selector: 'all', color: 'blue')

      expect(response).to be_success
      expect(response.object.count).to eq(2)
      expect(response.object.first).to eq(LIFX::HTTP::Loader::Result.new(
        'id' => 'd073d5017100',
        'label' => 'Bright 1',
        'status' => 'ok'
      ))
    end
  end

  it 'posts pulse' do
    VCR.use_cassette('pulse') do
      response = client.run_lights_pulse_effect(selector: 'all', color: 'blue')

      expect(response).to be_success
      expect(response.object.count).to eq(2)
      expect(response.object.first).to eq(LIFX::HTTP::Loader::Result.new(
        'id' => 'd073d5017100',
        'label' => 'Bright 1',
        'status' => 'ok'
      ))
    end
  end
end

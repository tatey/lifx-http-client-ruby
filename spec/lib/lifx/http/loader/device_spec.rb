require 'lifx/http/loader/device'

RSpec.describe LIFX::HTTP::Loader::Device do
  it 'is connected' do
    expect(new_device('connected' => true)).to be_connected
  end

  it 'is not connected' do
    expect(new_device('connected' => false)).to_not be_connected
  end

  it 'parses the last_seen timestamp' do
    device = new_device(last_seen: '2015-03-02T10:03:46.848+00:00')

    expect(device.last_seen.to_i).to eq(1425290626)
  end

  def new_device(overrides = {})
    LIFX::HTTP::Loader::Device.new({
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
      'last_seen' => '2015-03-02T10:03:46.848+00:00',
      'seconds_since_seen' => 0.002248558
    }.merge(overrides))
  end
end

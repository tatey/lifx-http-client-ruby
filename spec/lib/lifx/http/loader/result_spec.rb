require 'lifx/http/loader/result'

RSpec.describe LIFX::HTTP::Loader::Result do
  it 'is ok when status is ok' do
    expect(new_result('status' => 'ok')).to be_ok
  end

  it 'is timed out when status is timed_out' do
    expect(new_result('status' => 'timed_out')).to be_timed_out
  end

  it 'is offline when status is offline' do
    expect(new_result('status' => 'offline')).to be_offline
  end

  def new_result(overrides = {})
    LIFX::HTTP::Loader::Result.new({
      'id' => 'd073d5017100'
    }.merge(overrides))
  end
end

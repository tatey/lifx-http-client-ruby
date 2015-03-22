require 'json'
require 'lifx/http/response'

RSpec.describe LIFX::HTTP::Response do
  it 'is has a nicely formatted #inspect string' do
    raw = double('Net::HTTP::Response', body: JSON.dump([{id: 'd073d5017100', status: 'ok'}]), code: '200')
    response = LIFX::HTTP::Response.new(raw: raw, loader: LIFX::HTTP::Loader::Result, expects: [200])

    expect(response.inspect).to eq(%{#<LIFX::HTTP::Response status: 200, body: [#<LIFX::HTTP::Loader::Result id: "d073d5017100", status: "ok">]>})
  end
end

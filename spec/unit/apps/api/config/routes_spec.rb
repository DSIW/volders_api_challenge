RSpec.describe Api.routes do
  it 'generates "/users"' do
    actual = described_class.path(:users)
    expect(actual).to eq '/users'
  end

  it 'recognizes "POST /users"' do
    env = Rack::MockRequest.env_for('/users', method: 'POST')
    route = described_class.recognize(env)

    expect(route).to be_routable

    expect(route.path).to   eq '/users'
    expect(route.verb).to   eq 'POST'
    expect(route.params).to eq({})
  end

  it 'generates "/contracts"' do
    actual = described_class.path(:contracts)
    expect(actual).to eq '/contracts'
  end

  it 'recognizes "POST /contracts"' do
    env = Rack::MockRequest.env_for('/contracts', method: 'POST')
    route = described_class.recognize(env)

    expect(route).to be_routable

    expect(route.path).to   eq '/contracts'
    expect(route.verb).to   eq 'POST'
    expect(route.params).to eq({})
  end

  it 'generates "/contracts/1"' do
    actual = described_class.path(:contract, 1)
    expect(actual).to eq '/contracts/1'
  end

  it 'recognizes "GET /contracts/1"' do
    env = Rack::MockRequest.env_for('/contracts/1', method: 'GET')
    route = described_class.recognize(env)

    expect(route.path).to   eq '/contracts/1'
    expect(route.verb).to   eq 'GET'
    expect(route.params).to eq({id: '1'})
  end

  it 'recognizes "DELETE /contracts/1"' do
    env = Rack::MockRequest.env_for('/contracts/1', method: 'DELETE')
    route = described_class.recognize(env)

    expect(route.path).to   eq '/contracts/1'
    expect(route.verb).to   eq 'DELETE'
    expect(route.params).to eq({id: '1'})
  end
end

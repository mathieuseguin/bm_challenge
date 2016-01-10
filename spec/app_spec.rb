require File.expand_path '../spec_helper.rb', __FILE__

describe 'StripeProxy' do
  it 'should delete data from the Stripe API' do
    get '/v1/coupons/Chuy5'
    parsed_res = JSON.parse(last_response.body)

    expect(last_response).to_not be_ok
    expect(parsed_res).to be_kind_of(Hash)
    expect(parsed_res['error']['message']).to eq('No such coupon: Chuy5')
  end

  it 'should get data from the Stripe API' do
    get '/v1/events/evt_17RIwm2eZvKYlo2CNnOoBa3B'
    parsed_res = JSON.parse(last_response.body)

    expect(last_response).to be_ok
    expect(parsed_res).to be_kind_of(Hash)
    expect(parsed_res['id']).to eq('evt_17RIwm2eZvKYlo2CNnOoBa3B')
  end

  it 'should post data to the Stripe API' do
    post '/v1/charges/ch_17RIcn2eZvKYlo2CeB9DoePz', description: 'Charge for test@example.com'
    parsed_res = JSON.parse(last_response.body)

    expect(last_response).to be_ok
    expect(parsed_res).to be_kind_of(Hash)
    expect(parsed_res['id']).to eq('ch_17RIcn2eZvKYlo2CeB9DoePz')
  end

  it 'should get data from the cache', :with_webmock do
    ['/v1/events', '/v1/events/evt_17RIwm2eZvKYlo2CNnOoBa3B'].each do |path|
      url = "https://#{ENV['API_USER']}:#{ENV['API_PASS']}@#{ENV['API_HOST']}#{path}"
      stub = stub_request(:get, url).to_return(status: 200, body: '{ "json_test": true }', headers: {})

      2.times do
        get path
        parsed_res = JSON.parse(last_response.body)
        expect(parsed_res).to eq('json_test' => true)
      end

      expect(stub).to have_been_requested.once
    end
  end
end

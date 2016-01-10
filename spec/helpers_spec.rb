require File.expand_path '../spec_helper.rb', __FILE__

describe 'Sinatra::StripeProxy::Helpers' do
  let(:class_instance) do
    (Class.new { include Sinatra::StripeProxy::Helpers }).new
  end

  describe '#get_data' do
    let(:request) do
      request = double('request')
      allow(request).to receive(:path_info).and_return('/v1/events/evt_17RIwm2eZvKYlo2CNnOoBa3B')
      allow(request).to receive(:query_string).and_return('')
      request
    end

    it 'should get data from the Stripe API' do
      res = class_instance.get_data(request)
      parsed_res = JSON.parse(res)

      expect(parsed_res).to be_kind_of(Hash)
      expect(parsed_res['id']).to eq('evt_17RIwm2eZvKYlo2CNnOoBa3B')
    end
  end

  describe '#post_data' do
    let(:request) do
      request = double('request')
      allow(request).to receive(:path_info).and_return('/v1/charges/ch_17RIcn2eZvKYlo2CeB9DoePz')
      allow(request).to receive(:query_string).and_return('')
      allow(request).to receive(:params).and_return(description: 'Charge for test@example.com')
      request
    end

    let(:data) { { description: 'Charge for test@example.com' } }

    it 'should post data to the Stripe API' do
      res = class_instance.post_data(request)
      parsed_res = JSON.parse(res)
      expect(parsed_res).to be_kind_of(Hash)
      expect(parsed_res['id']).to eq('ch_17RIcn2eZvKYlo2CeB9DoePz')
    end
  end
end

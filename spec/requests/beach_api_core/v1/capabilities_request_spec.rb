require 'rails_helper'

module BeachApiCore
  describe 'V1::Capability', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      let(:service) { create :service }

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_service_capabilities_path(service) }
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_service_capabilities_path(service), headers: invalid_bearer_auth }
      end

      it 'should successfully create capability' do
        expect { post beach_api_core.v1_service_capabilities_path(service), headers: developer_bearer_auth }
          .to change(Capability, :count).by(1)
        expect(response.status).to eq 201
        expect(json_body[:service]).to be_present
      end
    end

    describe 'when destroy' do
      let!(:capability) { create :capability, application: oauth_application }

      it 'should successfully destroy capability' do
        delete beach_api_core.v1_service_capabilities_path(capability.service), headers: developer_bearer_auth
        expect(response.status).to eq(200)
        expect(Capability.find_by(id: capability.id)).to be_blank
      end

      it_behaves_like 'an authenticated resource' do
        before { delete beach_api_core.v1_service_capabilities_path(capability) }
      end
    end
  end
end
require 'rails_helper'

UPDATE_SERVICE_PARAMS = { title: Faker::Name.title, name: Faker::Name.title.parameterize(separator: '_'),
                          description: Faker::Lorem.sentence }

module BeachApiCore
  describe 'V1::Service', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when index' do
      let!(:service) { (create :capability, application: oauth_application).service }
      let!(:other_service) { (create :capability).service }

      it 'should return current application services' do
        get beach_api_core.v1_services_path, headers: developer_bearer_auth
        expect(response.status).to eq 200
        expect(json_body[:services].length).to eq 1
        expect(json_body[:services].first[:id]).to eq service.id
        expect(json_body[:services].first.keys).to contain_exactly(:id, :name, :title, :description, :icon_url)
      end

      it_behaves_like 'an forbidden resource' do
        before { get beach_api_core.v1_services_path, headers: bearer_auth }
      end

      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_services_path }
      end
    end

    describe 'when update' do
      let!(:service) { create :service }

      it_behaves_like 'an authenticated resource' do
        before { patch beach_api_core.v1_service_path(service) }
      end

      it_behaves_like 'an authenticated resource' do
        before { patch beach_api_core.v1_service_path(service), params: nil, headers: invalid_bearer_auth }
      end

      it 'should update service' do
        patch beach_api_core.v1_service_path(service), params: { service: UPDATE_SERVICE_PARAMS }, headers: developer_bearer_auth
        expect(response.status).to eq 200
        expect(json_body[:service]).to be_present
        UPDATE_SERVICE_PARAMS.each { |key, value| expect(service.reload.send(key)).to eq value }
      end

      context 'icon' do
        let!(:service) { create :service }
        let!(:simple_icon) { fixture_file_upload('spec/uploads/test.png', 'image/png') }
        let(:base64_icon) { "data:image/png;base64,#{Base64.encode64(File.read('spec/uploads/test.png'))}" }

        it 'should save the icon' do
          expect { patch beach_api_core.v1_service_path(service), params: { service: { icon_attributes: { file: simple_icon } } },
                                                   headers: developer_bearer_auth }
            .to change(Asset, :count).by(1)
          expect(service.icon).to be_present
        end

        it 'should save icon as base64' do
          expect { patch beach_api_core.v1_service_path(service), params: { service: { icon_attributes: { base64: base64_icon } } },
                                                   headers: developer_bearer_auth }
            .to change(Asset, :count).by(1)
          expect(service.icon).to be_present
        end
      end
    end
  end
end
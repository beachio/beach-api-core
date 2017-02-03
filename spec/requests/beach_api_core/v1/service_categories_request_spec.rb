require 'rails_helper'

module BeachApiCore
  describe 'V1::ServiceCategory', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      it_behaves_like 'an forbidden resource' do
        before { post beach_api_core.v1_service_categories_path, headers: bearer_auth }
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_service_categories_path }
      end

      it 'should successfully create service category' do
        expect { post beach_api_core.v1_service_categories_path, params: { service_category: { name: Faker::Name.title } },
                                                  headers: developer_bearer_auth }
            .to change(ServiceCategory, :count).by(1)
        expect(json_body[:service_category]).to be_present
      end
    end

    describe 'when index' do
      let!(:service_categories) { create_list :service_category, 2, :with_services }

      it 'should return services categories' do
        get beach_api_core.v1_service_categories_path, headers: developer_bearer_auth
        expect(response.status).to eq 200
        expect(json_body[:service_categories]).to be_present
        expect(json_body[:service_categories].first[:services]).to be_present
      end

      it_behaves_like 'an forbidden resource' do
        before { get beach_api_core.v1_service_categories_path, headers: bearer_auth }
      end

      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_service_categories_path }
      end
    end

    describe 'when update' do
      let!(:service_category) { create :service_category }

      it_behaves_like 'an authenticated resource' do
        before { patch beach_api_core.v1_service_category_path(service_category) }
      end

      it_behaves_like 'an authenticated resource' do
        before { patch beach_api_core.v1_service_category_path(service_category), params: nil, headers: invalid_bearer_auth }
      end

      it 'should update service category' do
        new_name = Faker::Name.title
        patch beach_api_core.v1_service_category_path(service_category), params: { service_category: { name: new_name } },
                                                          headers: developer_bearer_auth
        expect(response.status).to eq 200
        expect(json_body[:service_category]).to be_present
        expect(service_category.reload.name).to eq new_name
      end
    end
  end
end
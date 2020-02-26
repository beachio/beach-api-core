require 'rails_helper'

module BeachApiCore
  describe 'V1::ServiceCategory', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    SERVICE_CATEGORY_KEYS = %i(id name services).freeze

    describe 'when create' do
      it_behaves_like 'an forbidden resource' do
        before { post beach_api_core.v1_service_categories_path, headers: bearer_auth }
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_service_categories_path }
      end

      it 'should successfully create service category' do
        expect do
          post beach_api_core.v1_service_categories_path,
               params: { service_category: { name: Faker::Job.title } },
               headers: developer_bearer_auth
        end.to change(ServiceCategory, :count).by(1)
        expect(response.status).to eq 201
        expect(json_body[:service_category]).to be_present
        expect(json_body[:service_category].keys).to contain_exactly(*SERVICE_CATEGORY_KEYS)
      end
    end

    describe 'when index' do
      let!(:service_categories) { create_list :service_category, 2, :with_services }

      it 'should return services categories' do
        get beach_api_core.v1_service_categories_path, headers: developer_bearer_auth
        expect(response.status).to eq 200
        expect(json_body[:service_categories]).to be_present
        expect(json_body[:service_categories].first.keys).to contain_exactly(*SERVICE_CATEGORY_KEYS)
        expect(json_body[:service_categories].first[:services]).to be_present
      end

      it_behaves_like 'an forbidden resource' do
        before do
          headers = bearer_auth
          get beach_api_core.v1_service_categories_path, headers: headers
        end
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
        before do
          patch beach_api_core.v1_service_category_path(service_category),
                headers: invalid_bearer_auth
        end
      end

      it 'should update service category' do
        new_name = Faker::Job.title
        patch beach_api_core.v1_service_category_path(service_category),
              params: { service_category: { name: new_name } },
              headers: developer_bearer_auth
        expect(response.status).to eq 200
        expect(json_body[:service_category]).to be_present
        expect(json_body[:service_category].keys).to contain_exactly(*SERVICE_CATEGORY_KEYS)
        expect(service_category.reload.name).to eq new_name
      end
    end
  end
end

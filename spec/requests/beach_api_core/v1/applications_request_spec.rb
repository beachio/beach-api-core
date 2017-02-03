require 'rails_helper'

module BeachApiCore
  describe 'V1::Application', type: :request do

    describe 'when index' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_applications_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_applications_path, headers: invalid_bearer_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { get beach_api_core.v1_applications_path, headers: bearer_auth }
        end
      end

      context 'when valid' do
        it do
          get beach_api_core.v1_applications_path, headers: developer_bearer_auth
          expect(response.status).to eq(200)
          expect(json_body[:applications]).to be_present
          expect(json_body[:applications].first.keys).to contain_exactly(:id, :name)
        end
      end
    end

    describe 'when create' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_applications_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_applications_path, headers: invalid_bearer_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { post beach_api_core.v1_applications_path, headers: bearer_auth }
        end
      end

      context 'when valid' do
        it do
          post beach_api_core.v1_applications_path, params: { application: { name: Faker::App.name,
                                                              redirect_uri: Faker::Internet.redirect_uri } },
               headers: developer_bearer_auth
          expect(response.status).to eq(200)
          expect(json_body[:application]).to be_present
        end
      end
    end

    describe 'when show' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      let!(:another_oauth_application) { create :oauth_application, owner: create(:developer) }

      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_application_path(oauth_application) }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_application_path(oauth_application), headers: invalid_bearer_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { get beach_api_core.v1_application_path(oauth_application), headers: bearer_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { get beach_api_core.v1_application_path(another_oauth_application), headers: developer_bearer_auth }
        end
      end

      context 'when valid' do
        it do
          get beach_api_core.v1_application_path(oauth_application), headers: developer_bearer_auth
          expect(response.status).to eq(200)
          expect(json_body[:application]).to be_present
        end
      end
    end

    describe 'when update' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      let!(:another_oauth_application) { create :oauth_application, owner: create(:developer) }

      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { patch beach_api_core.v1_application_path(oauth_application),
                         params: { application: { name: Faker::App.name } } }
        end
        it_behaves_like 'an authenticated resource' do
          before { patch beach_api_core.v1_application_path(oauth_application),
                         params: { application: { name: Faker::App.name } },
                         headers: invalid_bearer_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { patch beach_api_core.v1_application_path(oauth_application),
                         params: { application: { name: Faker::App.name } },
                         headers: bearer_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { patch beach_api_core.v1_application_path(another_oauth_application),
                         params: { application: { name: Faker::App.name } },
                         headers: developer_bearer_auth }
        end
      end

      context 'when valid' do
        it do
          patch beach_api_core.v1_application_path(oauth_application),
                params: { application: { name: Faker::App.name } },
                headers: developer_bearer_auth
          expect(response.status).to eq(200)
          expect(json_body[:application]).to be_present
          expect(json_body[:application][:name]).not_to eq oauth_application.name
        end
      end
    end

    describe 'when destroy' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      let!(:another_oauth_application) { create :oauth_application, owner: create(:developer) }

      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_application_path(oauth_application) }
        end
        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_application_path(oauth_application), headers: invalid_bearer_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { delete beach_api_core.v1_application_path(oauth_application), headers: bearer_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { delete beach_api_core.v1_application_path(another_oauth_application), headers: developer_bearer_auth }
        end
      end

      context 'when valid' do
        it do
          delete beach_api_core.v1_application_path(oauth_application), headers: developer_bearer_auth
          expect(response.status).to eq(200)
          expect(Doorkeeper::Application.find_by(id: oauth_application.id)).to be_blank
        end
      end
    end
  end
end
require 'rails_helper'

module BeachApiCore
  describe 'V1::Favourite', type: :request do
    FAVOURITE_KEYS = [:id, :favouritable_id, :favouritable_type].freeze

    describe 'when index' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_favourites_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_favourites_path, headers: invalid_bearer_auth }
        end
      end

      context 'when valid' do
        before do
          create :favourite, user: oauth_user, favouritable: oauth_user
          create :favourite
        end
        it 'without filter' do
          get beach_api_core.v1_favourites_path, headers: bearer_auth
          expect(response.status).to eq 200
          expect(json_body[:favourites]).to be_present
          expect(json_body[:favourites].size).to eq 1
          expect(json_body[:favourites].first.keys).to contain_exactly(*FAVOURITE_KEYS)
        end

        context 'when filter exists' do
          it do
            get beach_api_core.v1_favourites_path(
              favouritable_type: BeachApiCore::Favourite.name
            ), headers: bearer_auth
            expect(response.status).to eq 200
            expect(json_body[:favourites]).to be_empty
          end

          it do
            get beach_api_core.v1_favourites_path(
              favouritable_type: BeachApiCore::User.name
            ), headers: bearer_auth
            expect(response.status).to eq 200
            expect(json_body[:favourites]).to be_present
          end
        end
      end
    end

    describe 'when create' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_favourites_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_favourites_path, headers: invalid_bearer_auth }
        end
      end

      context 'when valid' do
        it do
          post beach_api_core.v1_favourites_path,
               params: {
                 favourite: { favouritable_id: oauth_application.id,
                              favouritable_type: oauth_application.class }
               },
               headers: bearer_auth
          expect(response.status).to eq 200
          expect(json_body[:favourite]).to be_present
          expect(json_body[:favourite].keys).to contain_exactly(*FAVOURITE_KEYS)
          expect(oauth_user.favourites.map(&:favouritable)).to contain_exactly(oauth_application)
        end
      end
    end

    describe 'when destroy' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      context 'when invalid' do
        let(:favourite) { create :favourite }
        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_favourite_path(favourite) }
        end
        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_favourite_path(favourite), headers: invalid_bearer_auth }
        end

        context 'should not to be able remove not owned item' do
          it_behaves_like 'an forbidden resource' do
            before { delete beach_api_core.v1_favourite_path(favourite), headers: bearer_auth }
          end
        end
      end

      context 'when valid' do
        it 'should remove favourite' do
          favourite = create(:favourite, user: oauth_user)
          delete beach_api_core.v1_favourite_path(favourite), headers: bearer_auth
          expect(response.status).to eq 204
          expect(Favourite.find_by(id: favourite.id)).to be_blank
        end
      end
    end
  end
end

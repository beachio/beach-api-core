require 'rails_helper'

module BeachApiCore
  describe 'V1::UserAccess', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    USER_ACCESS_KEYS = %i(id access_level_id keeper_id keeper_type user)

    describe 'when create' do
      let(:organisation) { create :organisation }
      let(:other_organisation) { create :organisation }
      let(:access_level) { create :access_level }
      let(:user) { (create :membership, group: organisation).member }
      let(:other_user) { (create :membership, group: other_organisation).member }
      before do
        create :membership, group: organisation, member: oauth_user, owner: true
        create :membership, group: other_organisation, member: oauth_user
      end

      it_behaves_like 'an authenticated resource' do
        before do
          access_token.update(organisation: organisation)
          post beach_api_core.v1_user_accesses_path,
               params: { user_access: { access_level_id: access_level.id, user_id: user.id } }
        end
      end

      it_behaves_like 'an forbidden resource' do
        before do
          access_token.update(organisation: other_organisation)
          post beach_api_core.v1_user_accesses_path,
               params: { user_access: { access_level_id: access_level.id, user_id: other_user.id } },
               headers: bearer_auth
        end
      end

      it_behaves_like 'resource not found' do
        before do
          access_token.update(organisation: organisation)
          post beach_api_core.v1_user_accesses_path,
               params: { user_access: { access_level_id: access_level.id, user_id: other_user.id } },
               headers: bearer_auth
        end
      end

      context 'when valid' do
        before do
          access_token.update(organisation: organisation)
          post beach_api_core.v1_user_accesses_path,
               params: { user_access: { access_level_id: access_level.id, user_id: user.id } },
               headers: bearer_auth
        end
        it do
          expect(response.status).to eq 201
          expect(json_body[:user_access].keys).to contain_exactly(*USER_ACCESS_KEYS)
        end
      end
    end

    describe 'when destroy' do
      let(:organisation) { create :organisation }
      let(:other_organisation) { create :organisation }
      let(:user_access) { create :user_access, keeper: organisation }
      let(:other_user_access) { create :user_access }
      before do
        create :membership, group: organisation, member: oauth_user, owner: true
        create :membership, group: other_organisation, member: oauth_user
      end

      it_behaves_like 'an authenticated resource' do
        before do
          access_token.update(organisation: organisation)
          delete beach_api_core.v1_user_access_path(user_access)
        end
      end

      it_behaves_like 'an forbidden resource' do
        before do
          access_token.update(organisation: other_organisation)
          delete beach_api_core.v1_user_access_path(user_access), headers: bearer_auth
        end
      end

      it_behaves_like 'resource not found' do
        before do
          access_token.update(organisation: organisation)
          delete beach_api_core.v1_user_access_path(other_user_access), headers: bearer_auth
        end
      end

      context 'when valid' do
        let!(:user_access) { create :user_access, keeper: organisation }
        before do
          access_token.update(organisation: organisation)
          delete beach_api_core.v1_user_access_path(user_access), headers: bearer_auth
        end
        it do
          expect(response.status).to eq 204
          expect(UserAccess.find_by(id: user_access.id)).to be_blank
        end
      end
    end
  end
end

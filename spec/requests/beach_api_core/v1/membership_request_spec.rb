require 'rails_helper'

module BeachApiCore
  describe 'V1::Membership', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'
    include_context 'controller actions permissions'

    describe 'when create' do
      let(:organisation) { create :organisation }
      let(:user) { create :user }
      it_behaves_like 'an authenticated resource' do
        before do
          post beach_api_core.v1_memberships_path,
               params: {
                 membership: { member_id: user.id,
                               member_type: 'User' },
                 group_id: organisation.id,
                 group_type: 'Organisation'
               }
        end
      end

      it 'should create membership' do
        expect do
          post beach_api_core.v1_memberships_path,
               params: {
                 membership: { owner: true,
                               member_id: user.id,
                               member_type: 'User' },
                 group_id: organisation.id,
                 group_type: 'Organisation'
               },
               headers: bearer_auth
        end.to change(Membership, :count).by(1)
        expect(response.status).to eq 201
      end
    end

    describe 'when destroy' do
      let(:membership) { create :membership }

      it_behaves_like 'an authenticated resource' do
        before { delete beach_api_core.v1_membership_path(membership) }
      end

      it_behaves_like 'an forbidden resource' do
        before { delete beach_api_core.v1_membership_path(membership), headers: bearer_auth }
      end

      it 'should allow group owner to destroy membership' do
        membership = create :membership, member: oauth_user, owner: true
        delete beach_api_core.v1_membership_path(membership), headers: bearer_auth
        expect(response.status).to eq 204
        expect(Membership.find_by(id: membership.id)).to be_blank
      end
    end
  end
end

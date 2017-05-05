require 'rails_helper'

module BeachApiCore
  describe 'V1::Invitation', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when index' do
      let!(:organisation) do
        (create :membership, member: oauth_user, group: (create :organisation), owner: true).group
      end

      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_invitations_path }
      end

      describe 'should list all group invitations' do
        before do
          create :invitation
          @invitation = create :invitation, group: organisation
        end
        it do
          get beach_api_core.v1_invitations_path,
              params: {
                group_type: 'Organisation',
                group_id: organisation.id
              },
              headers: bearer_auth
          expect(json_body[:invitations]).to be_present
          expect(json_body[:invitations].length).to eq 1
          expect(json_body[:invitations].first[:id]).to eq @invitation.id
        end
      end
    end

    describe 'when create' do
      let(:team) { create :team }
      it_behaves_like 'an authenticated resource' do
        before do
          post beach_api_core.v1_invitations_path,
               params: { invitation: { email: Faker::Internet.email },
                         group_id: team.id,
                         group_type: 'Team' }
        end
      end

      it 'should create an invitation' do
        expect do
          post beach_api_core.v1_invitations_path,
               params: {
                 invitation: { email: Faker::Internet.email,
                               first_name: Faker::Name.first_name,
                               last_name: Faker::Name.last_name,
                               role_ids: [(create :role).id] },
                 group_id: team.id,
                 group_type: 'Team' },
               headers: bearer_auth
        end.to change(Invitation, :count).by(1)
           .and change(ActionMailer::Base.deliveries, :count).by(1)
        expect(Invitation.last.user).to eq(oauth_user)
      end
    end

    describe 'when destroy' do
      let!(:organisation) do
        (create :membership, member: oauth_user, group: (create :organisation), owner: true).group
      end
      before do
        @invitation = create :invitation, group: organisation, user: oauth_user
        @other_invitation = create :invitation, group: organisation, user: oauth_user
        create :invitation, invitee: @invitation.invitee, email: @invitation.invitee.email
      end

      it_behaves_like 'an authenticated resource' do
        before { delete beach_api_core.v1_invitation_path(@invitation) }
      end

      it 'should destroy an invitation and invitee' do
        expect do
          delete beach_api_core.v1_invitation_path(@invitation), headers: bearer_auth
        end.to change(Invitation, :count).by(-2).and change(User, :count).by(-1)
        expect(response.status).to eq 204
      end

      it 'should not destroy an active user' do
        @other_invitation.invitee.active!
        expect do
          delete beach_api_core.v1_invitation_path(@other_invitation), headers: bearer_auth
        end.to change(Invitation, :count).by(-1).and change(User, :count).by(0)
      end
    end
  end
end

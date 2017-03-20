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

      describe 'should list all organisation invitations' do
        before do
          create :invitation
          @invitation = create :invitation, group: organisation
        end
        it do
          get beach_api_core.v1_invitations_path, headers: bearer_auth
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
               params: { invitation: { email: Faker::Internet.email }, group_id: team.id, group_type: 'Team' },
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
      let!(:invitation) { create :invitation, group: organisation }

      it_behaves_like 'an authenticated resource' do
        before { delete beach_api_core.v1_invitation_path(invitation) }
      end

      it 'should destroy an invitation and return it' do
        delete beach_api_core.v1_invitation_path(invitation), headers: bearer_auth
        expect(json_body[:invitation]).to be_present
        expect(json_body[:invitation][:id]).to eq invitation.id
      end
    end
  end
end

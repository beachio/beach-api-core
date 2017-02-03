require 'rails_helper'

module BeachApiCore
  describe 'V1::Invitation', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      let(:team) { create :team }
      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_invitations_path,
                      params: { invitation: { email: Faker::Internet.email }, group_id: team.id, group_type: 'Team' } }
      end

      it 'should create an invitation' do
        expect do
          post beach_api_core.v1_invitations_path,
               params: { invitation: { email: Faker::Internet.email }, group_id: team.id, group_type: 'Team' },
               headers: bearer_auth
        end.to change(Invitation, :count).by(1)
           # .and change(ActionMailer::Base.deliveries, :count).by(1)
        expect(Invitation.last.user).to eq(oauth_user)
      end
    end
  end
end
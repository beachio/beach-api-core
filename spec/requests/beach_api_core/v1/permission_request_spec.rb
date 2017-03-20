require 'rails_helper'

module BeachApiCore
  describe 'V1::Permission', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when index' do
      before do
        @atom = create :atom
        @organisation = create :organisation
        create :membership, member: oauth_user, group: @organisation
        @role1 = create(:assignment, user: oauth_user, keeper: @organisation).role
        @role2 = create(:assignment, user: oauth_user, keeper: BeachApiCore::Instance.current).role
        @team1 = create :team
        create :membership, group: @team1, member: oauth_user
        @team2 = create :team
        create :membership, group: @team2, member: oauth_user

        create :permission, atom: @atom, keeper: oauth_user, actions: { create: true, read: false }
        create :permission, atom: @atom, keeper: @role1, actions: { read: true, create: false, execute: false }
        create :permission, atom: @atom, keeper: @role2, actions: { execute: true }
        create :permission, atom: @atom, keeper: @team1, actions: { update: true, delete: false }
        create :permission, atom: @atom, keeper: @team2, actions: { delete: true, update: false }        
      end

      it 'should return services categories' do
        get beach_api_core.v1_atom_permission_index_path(@atom), headers: bearer_auth
        actions = { create: true, read: true, update: true, delete: true, execute: false }
        expect(response.status).to eq 200
        expect(json_body[:actions]).to be_present
        expect(json_body[:actions]).to eq actions
      end

      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_atom_permission_index_path(@atom) }
      end
    end

  end
end

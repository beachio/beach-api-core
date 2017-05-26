require 'rails_helper'

module BeachApiCore
  describe 'V1::Team', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      it_behaves_like 'an authenticated resource' do
        before do
          post beach_api_core.v1_teams_path,
               params: { team: { name: Faker::Name.title } }
        end
      end

      context 'when valid' do
        before do
          post beach_api_core.v1_teams_path,
               params: { team: { name: Faker::Name.title } },
               headers: bearer_auth
        end
        it { expect(response.status).to eq 201 }
        it_behaves_like 'valid team response'
      end

      it 'should create an ownership record' do
        expect do
          post beach_api_core.v1_teams_path,
               params: { team: { name: Faker::Name.title } },
               headers: bearer_auth
        end.to change(oauth_user.memberships, :count).by(1)
        expect(Team.last.owners).to include(oauth_user)
      end

      it 'should create webhooks notifier job' do
        expect do
          post beach_api_core.v1_teams_path,
               params: { team: { name: Faker::Name.title } },
               headers: bearer_auth
        end.to change(WebhooksNotifier.jobs, :count).by(1)
      end
    end

    describe 'when update' do
      let(:team) { (create :membership, member: oauth_user).group }
      let(:owned_team) { (create :membership, member: oauth_user, owner: true).group }
      let(:new_name) { Faker::Name.title }

      context 'when valid' do
        before do
          patch beach_api_core.v1_team_path(owned_team),
                params: { team: { name: new_name } },
                headers: bearer_auth
        end

        it { expect(owned_team.reload.name).to eq new_name }
        it_behaves_like 'valid team response'
      end

      it_behaves_like 'an forbidden resource' do
        before do
          patch beach_api_core.v1_team_path(team),
                params: { team: { name: new_name } },
                headers: bearer_auth
        end
      end

      it_behaves_like 'an authenticated resource' do
        before do
          patch beach_api_core.v1_team_path(owned_team),
                params: { team: { name: new_name } }
        end
      end

      it_behaves_like 'an authenticated resource' do
        before do
          patch beach_api_core.v1_team_path(owned_team),
                params: { team: { name: new_name } },
                headers: invalid_bearer_auth
        end
      end
    end

    describe 'when destroy' do
      let(:owned_team) { (create :membership, member: oauth_user, owner: true).group }
      let(:team) { (create :membership, member: oauth_user).group }

      it 'should allow to delete the team' do
        delete beach_api_core.v1_team_path(owned_team), headers: bearer_auth
        expect(response.status).to eq 204
      end

      it_behaves_like 'an forbidden resource' do
        before { delete beach_api_core.v1_team_path(team), headers: bearer_auth }
      end
    end

    describe 'when show' do
      let(:owned_team) { (create :membership, member: oauth_user, owner: true).group }
      let(:owned_organisation) do
        (create :membership, member: oauth_user, group: (create :organisation), owner: true).group
      end

      let(:organisation_team) do
        (create :membership, group: owned_organisation, member: create(:team)).member
      end
      let(:team) { create :team }

      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_team_path(owned_team) }
      end
      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_team_path(owned_team), headers: invalid_bearer_auth }
      end
      it_behaves_like 'an forbidden resource' do
        before { get beach_api_core.v1_team_path(team), headers: bearer_auth }
      end

      context 'when valid' do
        before { get beach_api_core.v1_team_path(owned_team), headers: bearer_auth }
        it { expect(response.status).to eq 200 }
        it_behaves_like 'valid team response'
      end

      context 'when valid for owner organization' do
        before { get beach_api_core.v1_team_path(organisation_team), headers: bearer_auth }
        it { expect(response.status).to eq 200 }
        it_behaves_like 'valid team response'
      end

    end
  end
end

require 'rails_helper'

module BeachApiCore
  describe 'V1::Assignment', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      let(:organisation) { create :organisation }
      let(:other_organisation) { create :organisation }
      let(:role) { create :role }
      let(:user) { (create :membership, group: organisation).member }
      let(:other_user) { (create :membership, group: other_organisation).member }
      before do
        create :membership, group: organisation, member: oauth_user, owner: true
        create :membership, group: other_organisation, member: oauth_user
      end

      it_behaves_like 'an authenticated resource' do
        before do
          access_token.update(organisation: organisation)
          post beach_api_core.v1_assignments_path,
               params: { assignment: { role_id: role.id, user_id: user.id } }
        end
      end

      it_behaves_like 'an forbidden resource' do
        before do
          access_token.update(organisation: other_organisation)
          post beach_api_core.v1_assignments_path,
               params: { assignment: { role_id: role.id, user_id: other_user.id } }, headers: bearer_auth
        end
      end

      it_behaves_like 'resource not found' do
        before do
          access_token.update(organisation: organisation)
          post beach_api_core.v1_assignments_path,
                      params: { assignment: { role_id: role.id, user_id: other_user.id } }, headers: bearer_auth
        end
      end

      context 'when valid' do
        before do
          access_token.update(organisation: organisation)
          post beach_api_core.v1_assignments_path,
               params: { assignment: { role_id: role.id, user_id: user.id } }, headers: bearer_auth
        end
        it { expect(response.status).to eq(201) }
      end
    end

    describe 'when destroy' do
      let(:organisation) { create :organisation }
      let(:other_organisation) { create :organisation }
      let(:assignment) { create :assignment, keeper: organisation }
      let(:other_assignment) { create :assignment }
      before do
        create :membership, group: organisation, member: oauth_user, owner: true
        create :membership, group: other_organisation, member: oauth_user
      end

      it_behaves_like 'an authenticated resource' do
        before do
          access_token.update(organisation: organisation)
          delete beach_api_core.v1_assignment_path(assignment)
        end
      end

      it_behaves_like 'an forbidden resource' do
        before do
          access_token.update(organisation: other_organisation)
          delete beach_api_core.v1_assignment_path(assignment), headers: bearer_auth
        end
      end

      it_behaves_like 'resource not found' do
        before do
          access_token.update(organisation: organisation)
          delete beach_api_core.v1_assignment_path(other_assignment), headers: bearer_auth
        end
      end

      context 'when valid' do
        let!(:assignment) { create :assignment, keeper: organisation }
        before do
          access_token.update(organisation: organisation)
          delete beach_api_core.v1_assignment_path(assignment), headers: bearer_auth
        end
        it do
          expect(response.status).to eq(200)
          expect(Assignment.find_by(id: assignment.id)).to be_blank
        end
      end
    end
  end
end

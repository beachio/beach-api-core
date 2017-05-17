require 'rails_helper'

module BeachApiCore
  describe 'V1::Role', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when index' do
      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_roles_path }
      end

      describe 'should list all available roles' do
        before { 2.times { create :role } }
        it do
          get beach_api_core.v1_roles_path, headers: bearer_auth
          expect(json_body[:roles]).to be_present
          # 2 new roles + developer role
          expect(json_body[:roles].size).to eq 3
          expect(json_body[:roles].first.keys).to contain_exactly(:id, :name)
        end
      end
    end
  end
end

require 'rails_helper'

module BeachApiCore
  describe 'V1::Project', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      before { @project_params = { name: Faker::Name.title } }

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_projects_path, params: { project: @project_params } }
      end

      it 'should create a new project' do
        post beach_api_core.v1_projects_path,
             params: { project: @project_params },
             headers: bearer_auth
        expect(response).to have_http_status :created
        expect(json_body[:project]).to be_present
        expect(json_body[:project].keys).to contain_exactly(:id, :name)
        expect(json_body[:project][:name]).to eq(@project_params[:name])
      end
    end
  end
end

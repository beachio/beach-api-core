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

    describe 'when show' do
      context 'when owned project' do
        before { @project = create :project, user: oauth_user }

        it 'should return an existing project' do
          get beach_api_core.v1_project_path(@project),
              headers: bearer_auth
          expect(response).to have_http_status :ok
          expect(json_body[:project]).to be_present
          expect(json_body[:project][:name]).to eq @project.name
        end
      end

      context 'when not owned project' do
        before { @project = create :project }

        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_project_path(@project) }
        end

        it 'should not return project info' do
          get beach_api_core.v1_project_path(@project),
              headers: bearer_auth
          expect(response).to have_http_status :not_found
        end
      end
    end

    describe 'when destroy' do
      context 'when owned project' do
        before { @project = create :project, user: oauth_user }

        it 'should destroy a job' do
          delete beach_api_core.v1_project_path(@project),
                 headers: bearer_auth
          expect(response).to have_http_status :ok
          expect(json_body[:project]).to be_present
          expect(json_body[:project][:name]).to eq @project.name
          expect(Project.count).to eq 0
        end
      end

      context 'when not owned project' do
        before { @project = create :project }

        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_project_path(@project) }
        end

        it 'should not allow to destory a job' do
          delete beach_api_core.v1_project_path(@project),
                 headers: bearer_auth
          expect(response).to have_http_status :not_found
        end
      end
    end
  end
end

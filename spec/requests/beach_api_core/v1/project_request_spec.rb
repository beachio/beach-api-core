require 'rails_helper'

module BeachApiCore
  describe 'V1::Project', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    let!(:organisation) do
      (create :membership, member: oauth_user, group: (create :organisation)).group
    end

    before { access_token.update(organisation: organisation) }

    describe 'when create' do
      before do
        BeachApiCore::Instance.instance_variable_set('@_current', nil)
        @keeper = BeachApiCore::Instance.current
        @project_params = {
          project: {
            name: Faker::Name.title,
            project_keepers_attributes: [{ keeper_id: @keeper.id,
                                           keeper_type: @keeper.class.name }]
          }
        }
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_projects_path, params: { project: @project_params } }
      end

      it 'should create a new project' do
        post beach_api_core.v1_projects_path,
             params: @project_params,
             headers: bearer_auth
        expect(response).to have_http_status :created
        expect(json_body[:project]).to be_present
        expect(json_body[:project].keys).to contain_exactly(:id, :name, :project_keepers)
        expect(json_body[:project][:name]).to eq(@project_params[:project][:name])
        expect(json_body[:project][:project_keepers].size).to eq 1
        expect(json_body[:project][:project_keepers].first[:keeper_id]).to eq @keeper.id
        expect(Project.last.organisation_id).to eq organisation.id
      end
    end

    describe 'when show' do
      context 'when owned project' do
        before { @project = create :project, user: oauth_user, organisation: organisation }

        it 'should return an existing project' do
          get beach_api_core.v1_project_path(@project),
              headers: bearer_auth
          expect(response).to have_http_status :ok
          expect(json_body[:project]).to be_present
          expect(json_body[:project][:name]).to eq @project.name
        end
      end

      context 'when project from current organisation' do
        before { @project = create :project, user: create(:user), organisation: organisation }

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

    describe 'when update' do
      before do
        @project_params = { project: { name: Faker::Name.title } }
      end

      context 'when owned project' do
        before { @project = create :project, user: oauth_user, organisation: organisation }

        it 'should destroy a job' do
          put beach_api_core.v1_project_path(@project),
              params: @project_params,
              headers: bearer_auth
          expect(response).to have_http_status :ok
          expect(json_body[:project]).to be_present
          expect(json_body[:project][:name]).to eq @project_params[:project][:name]
        end
      end

      context 'when not owned project' do
        before { @project = create :project }

        it_behaves_like 'an authenticated resource' do
          before { put beach_api_core.v1_project_path(@project), params: @project_params }
        end

        it 'should not allow to destory a job' do
          put beach_api_core.v1_project_path(@project),
              params: @project_params,
              headers: bearer_auth
          expect(response).to have_http_status :not_found
        end
      end
    end

    describe 'when destroy' do
      context 'when owned project' do
        before { @project = create :project, user: oauth_user, organisation: organisation }

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

module ProjectsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/projects', t('api.resource_description.descriptions.projects.create')
  param :project, Hash, required: true do
    param :name, String, required: true
    param :project_keepers_attributes, Array do
      param :keeper_id, Integer
      param :keeper_type, String
    end
  end
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"project\": #{apipie_project_response}"
  def create
  end

  api :GET, '/projects/:id', t('api.resource_description.descriptions.projects.get')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"project\": #{apipie_project_response}"
  def show
  end

  api :PUT, '/projects/:id', t('api.resource_description.descriptions.projects.update')
  param :project, Hash, required: true do
    param :name, String, required: true
    param :project_keepers_attributes, Array do
      param :keeper_id, Integer
      param :keeper_type, String
    end
  end
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"project\": #{apipie_project_response}"
  def update
  end

  api :DELETE, '/projects/:id', t('api.resource_description.descriptions.projects.destroy')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"project\": #{apipie_project_response}"
  def destroy
  end
end

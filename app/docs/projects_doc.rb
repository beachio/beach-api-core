module ProjectsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/projects', 'Create a new project'
  param :project, Hash, required: true do
    param :name, String, required: true
  end
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"project\": #{apipie_project_response}"
  def create
  end
end

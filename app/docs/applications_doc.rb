module ApplicationsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/applications', 'Get list of applications'
  example "\"applications\": [#{apipie_application_response}, ...]"
  def index
  end

  api :POST, '/applications', 'Create an application'
  param :application, Hash, required: true do
    param :name, String, required: true
    param :redirect_uri, String, required: true
  end
  example "\"application\": #{apipie_application_response} \nfail: 'Errors Description'"
  def create
  end

  api :GET, '/applications/:id', 'GET an application'
  example "\"application\": #{apipie_application_response}"
  def show
  end

  api :PUT,' /applications/:id', 'Update an application'
  param :application, Hash, required: true do
    param :name, String
  end
  example "\"application\": #{apipie_application_response} \nfail: 'Errors Description'"
  def update
  end

  api :DELETE, '/applications/:id', 'Delete an application'
  example "success: 'Application has been destroyed' \nfail: 'Could not remove application'"
  def destroy
  end
end

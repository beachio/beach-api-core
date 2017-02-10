module BeachApiCore
  class V1::OrganisationsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end
    def_param_group :organisation do
      param :organisation, Hash, required: true do
        param :name, String, required: true
      end
    end

    api :POST, '/organisations', 'Create an organisation'
    param_group :organisation
    example "\"organisation\": #{apipie_organisation_response} \n fail: 'Errors Description'"
    def create
      result = BeachApiCore::OrganisationCreate.call(params: organisation_params, user: current_user,
                                                     application: current_application)
      if result.success?
        render_json_success(result.organisation, result.status, root: :organisation)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :GET, '/organisations/:id', 'Get organisation'
    example "\"organisation\": #{apipie_organisation_response}"
    def show
      authorize @organisation
      render_json_success(@organisation, :ok, root: :organisation)
    end

    api :PUT, '/organisations/:id', 'Update organisation'
    param_group :organisation
    example "\"organisation\": #{apipie_organisation_response} \n fail: 'Errors Description'"
    def update
      authorize @organisation
      result = BeachApiCore::OrganisationUpdate.call(organisation: @organisation, params: organisation_params)
      if result.success?
        render_json_success(@organisation, result.status, root: :organisation)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :DELETE, '/organisations/:id', 'Remove organisation'
    example "success: 'Organisation was successfully deleted' \n fail: 'Could not remove organisation'"
    def destroy
      authorize @organisation
      if @organisation.destroy
        render_json_success({ message: 'Organisation was successfully deleted' }, :ok)
      else
        render_json_error({ message: 'Could not remove organisation' }, :bad_request)
      end
    end

    private

    def organisation_params
      params.require(:organisation).permit(:name)
    end
  end
end

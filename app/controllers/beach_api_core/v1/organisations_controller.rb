module BeachApiCore
  class V1::OrganisationsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!

    def create
      result = BeachApiCore::OrganisationCreate.call(params: organisation_params, user: current_user,
                                                     application: current_application)
      if result.success?
        render_json_success(result.organisation, result.status, root: :organisation)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      authorize @organisation
      render_json_success(@organisation, :ok, root: :organisation)
    end

    def update
      authorize @organisation
      result = BeachApiCore::OrganisationUpdate.call(organisation: @organisation, params: organisation_params)
      if result.success?
        render_json_success(@organisation, result.status, root: :organisation)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

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
module BeachApiCore
  class V1::OrganisationsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include OrganisationsDoc
    before_action :doorkeeper_authorize!

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    def create
      result = BeachApiCore::OrganisationCreate.call(params: organisation_params, user: current_user,
                                                     application: current_application)
      if result.success?
        render_json_success(result.organisation, result.status, current_user: current_user, root: :organisation)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      authorize @organisation
      render_json_success(@organisation, :ok, current_user: current_user, root: :organisation)
    end

    def update
      authorize @organisation
      result = BeachApiCore::OrganisationUpdate.call(organisation: @organisation, params: organisation_params)
      if result.success?
        render_json_success(@organisation, result.status, current_user: current_user, root: :organisation)
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

    def users
      authorize current_organisation, :update?
      # @todo: exclude current user from response?
      users = current_organisation.users
      render_json_success(users, :ok, each_serializer: BeachApiCore::OrganisationUserSerializer,
                          keepers: current_keepers, current_user: current_user, root: :users)
    end

    private

    def organisation_params
      params.require(:organisation).permit(:name, logo_properties: logo_params, logo_image_attributes: [:file, :base64])
    end

    def logo_params
      logo_properties = (params[:organisation] && params[:organisation][:logo_properties]) ? params[:organisation][:logo_properties] : {}
      logo_properties.keys
    end
  end
end

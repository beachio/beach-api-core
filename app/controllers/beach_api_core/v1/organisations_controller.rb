module BeachApiCore
  class V1::OrganisationsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include OrganisationsDoc
    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/organisation.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      render_json_success(current_user.organisations, :ok, current_user: current_user, root: :organisations)
    end

    def create
      result = BeachApiCore::OrganisationCreate.call(params: organisation_params, user: current_user,
                                                     application: current_application, access_token: doorkeeper_token)
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
        head :no_content
      else
        render_json_error({ message: I18n.t('api.errors.could_not_remove',
                                            model: I18n.t('activerecord.models.organisation.downcase')) },
                          :bad_request)
      end
    end

    def users
      authorize current_organisation, :show?
      # @todo: exclude current user from response?
      users = current_organisation.users.order(:id)
      render_json_success(users, :ok,
                          each_serializer: BeachApiCore::OrganisationUserSerializer,
                          current_organisation: current_organisation,
                          root: :users)
    end

    def current
      get_resource
      authorize @organisation, :show?
      doorkeeper_token.update(organisation: @organisation)
      render_json_success
    end

    private

    def organisation_params
      params.require(:organisation).permit(:name, logo_properties: logo_params, logo_image_attributes: %i(file base64))
    end

    def logo_params
      logo_properties = if params[:organisation] && params[:organisation][:logo_properties]
                          params[:organisation][:logo_properties]
                        else
                          {}
                        end
      logo_properties.keys
    end
  end
end

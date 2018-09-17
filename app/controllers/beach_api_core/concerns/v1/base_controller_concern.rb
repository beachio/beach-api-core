module BeachApiCore::Concerns::V1::BaseControllerConcern
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token

    resource_description do
      api_version 'v1'
      formats ['json']
    end

    private

    def pundit_user
      UserContext.new(current_user, current_application)
    end

    def require_organisation!
      raise BeachApiCore::Exception::NotAcceptable unless current_organisation
    end

    def current_keepers
      [current_application, current_organisation, BeachApiCore::Instance.current].compact
    end

    def current_user
      @current_user ||= doorkeeper_token&.user
    end

    def current_application
      return unless doorkeeper_token&.application_id || @doorkeeper_application
      @current_application ||= Doorkeeper::Application
                               .find_by(id: doorkeeper_token&.application_id || @doorkeeper_application&.id)
    end

    def current_organisation
      # TODO: remove after frontend support multiple organisation
      if doorkeeper_token && !doorkeeper_token.organisation_id && current_user.organisations.any?
        doorkeeper_token.update(organisation: current_user.organisations.first)
      end
      @current_organisation ||= current_user.organisations.find_by(id: doorkeeper_token&.organisation_id)
    end

    def render_json_success(json = {}, status = :ok, params = {})
      render({ json: json, status: status }.merge(params))
    end

    def render_json_error(error = {}, status = :internal_server_error)
      render json: { error: error }, status: status
    end

    def get_service_name
      service_name = self.class.to_s.match(/::(\w*)Controller/)[1]
      if service_name == 'Uploads'
        service_name = 'images_and_assets'
      elsif service_name == 'Messages'
        service_name = 'chat'
      elsif service_name == 'Sessions' || service_name == 'Passwords'
        service_name = 'users_basic'
      elsif service_name == 'ServiceCategories'
        service_name = 'services'
      elsif service_name == 'Assignments' || service_name == 'Settings' || service_name == 'UserAccesses'
        service_name = 'organisations'
      elsif service_name == 'Entities' || service_name == 'Favourites' || service_name == 'Interactions'
        service_name = 'data_models'
      elsif service_name == 'Channels' || service_name == 'EntityMessages'
        service_name = 'notifications'
      elsif service_name == 'Memberships' || service_name == 'Roles' || service_name == 'Users'
        service_name = 'users_pro'
      end
      service_name
    end

    def authenticate_service_for_application
      service_name = get_service_name
      if current_application.nil?
        render_json_error({ message: I18n.t('api.resource_description.errors.unauthorized') }, :unauthorized)
      else
        service = BeachApiCore::Service.where("lower(name) like ?", "%#{service_name.downcase}%").first
        application_id = current_application.id
        unless service.nil?
          if BeachApiCore::Capability.where(:application_id => application_id, :service_id => service.id).empty?
            render_json_error({ message: I18n.t('api.resource_description.errors.unauthorized') }, :unauthorized)
          end
        end
      end
    end
  end
end

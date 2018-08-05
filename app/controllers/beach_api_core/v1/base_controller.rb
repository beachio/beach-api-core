require_dependency 'beach_api_core/application_controller'

module BeachApiCore
  class V1::BaseController < ApplicationController
    include Pundit
    include BeachApiCore::Concerns::V1::RescueFromConcern
    include BeachApiCore::Concerns::V1::BaseControllerConcern

    private

    def explicit_application_with_user_authorize!
      if !doorkeeper_token && request.headers['HTTP_AUTHORIZATION'].present? && application_authorized?
        if authenticate_service_for_doorkeeper_application(@doorkeeper_application.id)
          return @current_user = @doorkeeper_application.owner
        end
      end
      render_json_error({ message: I18n.t('api.resource_description.errors.unauthorized') }, :unauthorized)
    end

    def application_with_user_authorize!
      application_authorize! do
        @current_user = @doorkeeper_application.owner
      end
    end

    def application_authorize!
      if !doorkeeper_token && request.headers['HTTP_AUTHORIZATION'].present?
        unless application_authorized?
          return render_json_error({ message: I18n.t('api.resource_description.errors.unauthorized') },
                                   :unauthorized)
        end
        yield if block_given?
      else
        doorkeeper_authorize!
      end
    end

    def application_authorized?
      application_id, application_secret = request.headers['HTTP_AUTHORIZATION'].split(',')
      return false unless application_id.present? && application_secret.present?
      application_id.gsub!('application_id', '').to_s.strip!
      application_secret.gsub!('client_secret', '').to_s.strip!
      @doorkeeper_application = Doorkeeper::Application.find_by(uid: application_id)
      @doorkeeper_application.present? && @doorkeeper_application.secret == application_secret
    end

    def authorize_instance_owner!
      authorize Instance.current, :admin?
    end

    def get_service_name_for_application
      service_name = self.class.to_s.match(/::(\w*)Controller/)[1]
      if service_name == 'Atoms' || service_name == 'Permissions'
        service_name = 'security_pro'
      elsif service_name == 'Broadcasts'
        service_name = 'notifications'
      elsif service_name == 'Sessions' || service_name == 'Passwords'
        service_name = 'users_basic'
      elsif service_name == 'Users'
        service_name = 'users_pro'
      end
      service_name
    end

    def authenticate_service_for_doorkeeper_application(application_id = nil)
      if !application_id.nil? || !current_application.nil?
        service_name = get_service_name_for_application
        if service_name == 'users_basic'
          service = BeachApiCore::Service.where("lower(name) = ?", service_name.downcase).first
          if service.nil?
            service = BeachApiCore::Service.where("lower(name) = ?",'users_pro').first
            if service.nil?
              true
            else
              !BeachApiCore::Capability.where(:application_id => application_id, :service_id => service.id).empty?
            end
          else
            if BeachApiCore::Capability.where(:application_id => application_id, :service_id => service.id).empty?
              service = BeachApiCore::Service.where("lower(name) = ?",'users_pro').first
              if service.nil?
                true
              else
                !BeachApiCore::Capability.where(:application_id => application_id, :service_id => service.id).empty?
              end
            else
              true
            end
          end
        else
          service = BeachApiCore::Service.where("lower(name) = ?", service_name.downcase).first
          unless service.nil?
            if application_id.nil?
              application_id = current_application.id
              if BeachApiCore::Capability.where(:application_id => application_id, :service_id => service.id).empty?
                render_json_error({ message: I18n.t('api.resource_description.errors.unauthorized') },
                                  :unauthorized)
              end
            else
              !BeachApiCore::Capability.where(:application_id => application_id, :service_id => service.id).empty?
            end
          else
            true
          end
        end
      else
        render_json_error({ message: I18n.t('api.resource_description.errors.unauthorized') },
                          :unauthorized)
      end
    end
  end
end

module BeachApiCore
  class V1::WebhookConfigsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Admin::ApplicationHelper
    include BeachApiCore::WebhookConfigsDoc
    before_action :doorkeeper_authorize!

    resource_description do
      api_base_url '/v1'
      name "Webhook Configs"
    end

    def index
      webhook_config =  current_application.webhook_configs
      render_json_success(webhook_config, :ok,
                          each_serializer: BeachApiCore::WebhookConfigSerializer, root: :webhook_configs)
    end

    def show
      webhook_config =  current_application.webhook_configs.find_by(:id => params[:id])
      webhook_config.nil? ? render_json_error({message: "There are no such webhook config"}) : render_json_success(webhook_config, :ok, serializer: BeachApiCore::WebhookConfigSerializer, root: :webhook_config)
    end

    def create
      if admin_or_application_admin(current_application.id)
        if create_params[:webhook_parameters].blank? || create_params[:webhook_parameters].is_a?(Array)
          result = BeachApiCore::WebhookConfigCreate.call(:params => create_params, :webhook_parameters => create_params[:webhook_parameters], :application => current_application)
          if result.success?
            render_json_success(result.webhook_config, result.status, serializer: BeachApiCore::WebhookConfigSerializer, root: :webhook_config)
          else
            render_json_error({ message: result.message }, result.status)
          end
        else
          render_json_error({message: ["Wrong webhook config options"]})
        end
      else
        render_json_error({message: ["Access Denied"]})
      end
    end

    def update
      if admin_or_application_admin(current_application.id)
        webhook_config = current_application.webhook_configs.find_by(id: params[:id])
        if webhook_config.nil?
          render_json_error({message: "Wrong Webhook Config"})
        else
          check = true
          if !update_params[:webhook_parameters].blank? && update_params[:webhook_parameters].is_a?(Array)
            all_parameters = webhook_config.webhook_parametrs.pluck(:id)
            api_parameters = update_params[:webhook_parameters].map  {|parameter| parameter[:id] unless parameter[:id].blank?}
            check =  (api_parameters.compact - all_parameters).blank?
          end
          if check
            result = BeachApiCore::WebhookConfigUpdate.call(:webhook_config => webhook_config, params: update_params, :webhook_parameters => update_params[:webhook_parameters])
            if result.success?
              render_json_success(result.webhook_config, result.status, serializer: BeachApiCore::WebhookConfigSerializer, root: :webhook_config)
            else
              render_json_error({ message: result.message.first }, result.status)
            end
          else
            render_json_error({message: ["Wrong webhook config options"]})
          end
        end
      else
        render_json_error({message: ["Access Denied"]})
      end
    end

    def destroy
      if admin_or_application_admin(current_application.id)
        webhook_config = current_application.webhook_configs.find_by(id: params[:id])
        if webhook_config.nil?
          render_json_error({message: "There are no such webhook config"})
        else
          if webhook_config.destroy
            head :no_content
          else
            render_json_error({ message: "Could not remove webhook config"},
                              :bad_request)
          end

        end
      else
        render_json_error({message: "Access Denied"})
      end
    end

    def remove_parametr_from_config
      if admin_or_application_admin(current_application.id)
        parameter = BeachApiCore::WebhookParametr.find_by(:id => params[:parameter_id])
        if parameter.blank? || params[:id] != "#{parameter.webhook_config_id}"
          render_json_error({message: "Wrong parameter"})
        else
          if parameter.destroy
            head :no_content
          else
            render_json_error({message: "Could not remove webhook_parameter"},
                              :bad_request)
          end
        end
      else
        render_json_error({message: "Access Denied"})
      end
    end

    private
    def create_params
      params.require(:webhook_config).permit(:uri, :request_method, :request_body, :config_name, :webhook_parameters => [:name, :value])
    end

    def admin_or_application_admin(application_id)
      Doorkeeper::Application.find(application_id).admins.where(:id => current_user.id).empty? ? admin : true
    end

    def admin
      !BeachApiCore::Instance.current.admins.find_by(id: current_user.id).nil?
    end

    def update_params
      params.require(:webhook_config).permit(:uri, :request_method, :request_body, :config_name, :webhook_parameters => [:id, :name, :value])
    end

  end
end

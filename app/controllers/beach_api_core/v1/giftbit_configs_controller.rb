module BeachApiCore
  class V1::GiftbitConfigsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Admin::ApplicationHelper
    include BeachApiCore::GiftbitConfigsDoc
    before_action :doorkeeper_authorize!

    resource_description do
      api_base_url '/v1'
      name "Giftbit Configs"
    end

    def index
      giftbit_configs =  current_application.giftbit_configs
      render_json_success(giftbit_configs, :ok,
                          each_serializer: BeachApiCore::GiftbitConfigSerializer, root: :giftbit_configs)
    end

    def show
      giftbit_config = current_application.giftbit_configs.find_by(id: params[:id])
      giftbit_config.nil? ? render_json_error({message: "There are no such giftbit config"}) : render_json_success(giftbit_config, :ok, serializer: BeachApiCore::GiftbitConfigSerializer, root: :giftbit_config)
    end

    def create
      if admin_or_application_admin(current_application.id)
        if !create_params[:giftbit_brands_attributes].blank? && create_params[:giftbit_brands_attributes].is_a?(Array)
          result = BeachApiCore::GiftbitConfigCreate.call(:params => create_params, :giftbit_brands => create_params[:giftbit_brands_attributes], :application => current_application)
          if result.success?
            render_json_success(result.giftbit_config, result.status, serializer: BeachApiCore::GiftbitConfigSerializer, root: :giftbit_config)
          else
            render_json_error({ message: result.message }, result.status)
          end
        else
          render_json_error({message: ["Wrong giftbit config options"]})
        end
      else
        render_json_error({message: ["Access Denied"]})
      end
    end

    def brand_codes
      render_json_success({brands: giftbit_brand_list})
    end

    def update
      if admin_or_application_admin(current_application.id)
        giftbit_config = current_application.giftbit_configs.find_by(id: params[:id])
        if giftbit_config.nil?
          render_json_error({message: "Wrong Giftbit Config"})
        else
          check = true
          if !update_params[:giftbit_brands_attributes].blank? && update_params[:giftbit_brands_attributes].is_a?(Array)
            all_brands = giftbit_config.giftbit_brands.pluck(:id)
            params_brands = update_params[:giftbit_brands_attributes].map  {|brand| brand[:id] unless brand[:id].blank?}
            check =  (params_brands.compact - all_brands).blank?
          end
          if check
            result = BeachApiCore::GiftbitConfigUpdate.call(:giftbit_config => giftbit_config, params: update_params, :giftbit_brands => update_params[:giftbit_brands_attributes])
            if result.success?
              render_json_success(result.giftbit_config, result.status, serializer: BeachApiCore::GiftbitConfigSerializer, root: :giftbit_config)
            else
              render_json_error({ message: result.message.first }, result.status)
            end
          else
            render_json_error({message: ["Wrong giftbit config options"]})
          end
        end
      else
        render_json_error({message: ["Access Denied"]})
      end
    end

    def destroy
      if admin_or_application_admin(current_application.id)
        giftbit_config = current_application.giftbit_configs.find_by(id: params[:id])
        if giftbit_config.nil?
          render_json_error({message: "There are no such giftbit config"})
        else
          if giftbit_config.destroy
            head :no_content
          else
            render_json_error({ message: "Could not remove giftbit_config"},
                              :bad_request)
          end

        end
      else
        render_json_error({message: "Access Denied"})
      end
    end

    def remove_brand_from_config
      if admin_or_application_admin(current_application.id)
        brand = BeachApiCore::GiftbitBrand.find_by(:id => params[:brand_id])
        if brand.blank? || params[:id] != "#{brand.giftbit_config_id}"
          render_json_error({message: "Wrong brand"})
        else
          if brand.destroy
            head :no_content
          else
            render_json_error({message: "Could not remove giftbit_brand"},
                              :bad_request)
          end
        end
      else
        render_json_error({message: "Access Denied"})
      end
    end

    private
    def create_params
      params.require(:giftbit_config).permit(:config_name, :giftbit_token, :email_to_notify, :giftbit_brands_attributes => [:brand_code, :amount, :giftbit_email_template, :email_subject, :email_body, :gift_name])
    end

    def admin_or_application_admin(application_id)
      Doorkeeper::Application.find(application_id).admins.where(:id => current_user.id).empty? ? admin : true
    end

    def admin
      !BeachApiCore::Instance.current.admins.find_by(id: current_user.id).nil?
    end

    def update_params
      params.require(:giftbit_config).permit(:config_name, :giftbit_token, :email_to_notify, :giftbit_brands_attributes => [:id, :brand_code, :amount, :giftbit_email_template, :email_subject, :email_body, :gift_name])
    end

  end
end

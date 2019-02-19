module BeachApiCore
  class V1::AchievementsController < BeachApiCore::V1::BaseController
    include AchievementDoc
    before_action :doorkeeper_authorize!

    resource_description do
      api_base_url '/v1'
      name "Achievements"
    end

    def index
      achievements =  current_application.achievements.order('id desc')
      render_json_success(achievements, :ok,
                          each_serializer: BeachApiCore::AchievementSerializer, current_user: current_user, root: :achievements)
    end

    def show
      achievement = current_application.achievements.find_by(id: params[:id])
      achievement.nil? ? render_json_error({message: "There are no such achievement"}) : render_json_success(achievement, :ok, serializer: BeachApiCore::AchievementSerializer, current_user: current_user, root: :achievement)
    end

    def create
      if admin_or_application_admin(current_application.id)
        if !create_params[:mode_type].blank? && !create_params[:mode_id].blank?
          params[:achievement][:mode_type] = "BeachApiCore::" + create_params[:mode_type]
          result = BeachApiCore::AchievementCreate.call(:params => create_params, :application => current_application)
          if result.success?
            render_json_success(result.achievement, result.status, serializer: BeachApiCore::AchievementSerializer, root: :achievement)
          else
            render_json_error({ message: result.message }, result.status)
          end
        else
          render_json_error({message: ["mode_type and mode_id can't be blank"]})
        end
      else
        render_json_error({message: ["Access Denied"]})
      end
    end

    def update
      if admin_or_application_admin(current_application.id)
        achievement = current_application.achievements.find_by(id: params[:id])
        if achievement.nil?
          render_json_error({message: ["Wrong Achievement"]})
        else
          result = BeachApiCore::AchievementUpdate.call(:achievement => achievement, :params => update_params)
          if result.success?
            render_json_success(result.achievement, result.status, serializer: BeachApiCore::AchievementSerializer, root: :achievement)
          else
            render_json_error({ message: result.message }, result.status)
          end
        end
      else
        render_json_error({message: ["Access Denied"]})
      end
    end

    def destroy
      if admin_or_application_admin(current_application.id)
        achievement = current_application.achievements.find_by(id: params[:id])
        if achievement.nil?
          render_json_error({message: "There are no such achievement"})
        else
         if achievement.destroy
           head :no_content
         else
           render_json_error({ message: "Could not remove achievement"},
                             :bad_request)
         end

        end
      else
        render_json_error({message: "Access Denied"})
      end
    end

    private
    def create_params
      params.require(:achievement).permit(:achievement_name, :points_required, :max_rewards, :available_for, :reward_expiry, :mode_type, :mode_id,
                                          :reward_issue_requires_approval, :notify_by_email, :notify_via_broadcasts, :use_all_config_brands, giftbit_brand_ids: [])
    end

    def update_params
      params.require(:achievement).permit(:achievement_name, :max_rewards, :available_for, :reward_expiry,
                                          :reward_issue_requires_approval, :notify_by_email, :notify_via_broadcasts, :use_all_config_brands, giftbit_brand_ids: [])
    end

  end
end

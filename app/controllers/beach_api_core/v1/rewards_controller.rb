module BeachApiCore
  class V1::RewardsController < BeachApiCore::V1::BaseController
    include RewardsDoc
    before_action :doorkeeper_authorize!

    resource_description do
      api_base_url '/v1'
      name "Rewards"
    end

    def index
      achievement_ids = current_application.achievements.pluck(:id)
      rewards = current_user.rewards.where("achievement_id in (?)", achievement_ids).limit(10).order('id desc')
      render_json_success(rewards, :ok,
                          each_serializer: BeachApiCore::RewardSerializer, root: :rewards)
    end

    def cancel_gift
      reward = BeachApiCore::Reward.find_by(gift_uuid: params[:uuid])
      if reward.present? && reward.achievement.mode_type.match?(/GiftbitConfig/)
        api_key = reward.achievement.mode.giftbit_token.blank? ? ENV['GIFTBIT_TOKEN'] : reward.achievement.mode.giftbit_token
        result = BeachApiCore::GiftbitHelper.cancel_gift(api_key, params[:uuid])
        unless result['status'] == 422
          reward.update_attributes(status: 2, return_user_points: true)
          render_json_success(message: result['info']['message'], :reward => BeachApiCore::RewardSerializer.new(reward, root: :reward), status: result['status'])
        else
          update_gift_status(api_key, reward)
          render_json_error(message: result['info']['message'], status: result['status'])
        end
      else
        render_json_error({ message: 'Wrong uuid' })
      end
    end

    def resend_gift
      reward = BeachApiCore::Reward.find_by(gift_uuid: params[:uuid])
      if reward.present? && reward.achievement.mode_type.match?(/GiftbitConfig/)
        api_key = reward.achievement.mode.giftbit_token.blank? ? ENV['GIFTBIT_TOKEN'] : reward.achievement.mode.giftbit_token
        update_gift_status(api_key, reward)
        result = BeachApiCore::GiftbitHelper.resend_gift(api_key, reward.gift_uuid)
        result['status'] == 200 ? render_json_success(message: result['info']['message'], status: result['status']) :
            render_json_error(message: result['info']['message'], status: result['status'])
      else
        render_json_error({ message: 'Wrong uuid' })
      end
    end

    def show
      reward = current_user.rewards.find_by(:id => params[:id])
      if reward.nil? || reward.achievement.application_id != current_application.id
        render_json_error({message: "Wrong Reward"})
      else
        render_json_success(reward, :ok, serializer: BeachApiCore::RewardSerializer, root: :reward)
      end
    end

    def create
      achievement = current_application.achievements.find_by(id: create_params[:achievement_id])
      if achievement.nil?
        render_json_error({message: "Wrong Achievement"})
      else
        result = BeachApiCore::RewardCreate.call(:params => create_params, :reward_to => current_user)
        if result.success?
          render_json_success(result.reward, result.status, serializer: BeachApiCore::RewardSerializer, root: :reward)
        else
          render_json_error({ message: result.message }, result.status)
        end
      end
    end

    def confirm_reward
      if admin_or_application_admin(current_application.id)
        reward = BeachApiCore::Reward.find_by(id: params[:reward_id])
        if reward.blank?
          render_json_error({message: "Wrong Reward"})
        else
          reward.update_attribute(:confirmed, true)
          render_json_success(reward, :ok, serializer: BeachApiCore::RewardSerializer, root: :reward)
        end
      else
        render_json_error({message: "Access Denied"})
      end
    end



    def destroy
      if admin || application_admin(current_application.id)
        reward = BeachApiCore::Reward.find_by(:id => params[:id])
        reward = nil if reward.achievement.application_id != current_application.id && !admin
        if reward.nil?
          render_json_error({message: "Wrong Reward"})
        else
          if reward.destroy
            head :no_content
          else
            render_json_error({ message: "Could not remove reward"},
                              :bad_request)
          end
        end
      else
        render_json_error({message: "Access Denied"})
      end
    end

    private
    def create_params
      params.require(:reward).permit(:achievement_id, :giftbit_brand_id)
    end

    def update_gift_status api_key, reward
      gift_status = BeachApiCore::GiftbitHelper.gift_status(api_key, reward.gift_uuid)
      reward.update_status(gift_status)
    end

  end
end

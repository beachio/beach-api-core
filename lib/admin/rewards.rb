ActiveAdmin.register BeachApiCore::Reward, as: 'Reward' do
  menu priority: 65, parent: 'Achievements and Rewards'

  permit_params :achievement_id, :reward_to_id, :reward_to_type, :giftbit_brand_id, :status, :confirmed

  before_action :set_reward, only: [:resend_gift, :cancel_gift]
  before_action :update_status, only: [:show]

  collection_action :get_reward_config, method: :get do
    achievement = BeachApiCore::Achievement.find_by(id: params[:achievement_id])
    if achievement.available_for == 'users and devices'
      reward_to = BeachApiCore::User.all
      reward_to += BeachApiCore::Device.all
    else
      reward_to = BeachApiCore::Device.all if achievement.available_for == 'devices'
      reward_to = BeachApiCore::User.all  if achievement.available_for == 'users'
    end
    current_reward = BeachApiCore::Reward.find(params[:reward_id]) unless params[:reward_id].nil?
    reward_to = reward_to.map {|object| object.class.to_s == 'BeachApiCore::Device' ? ["Device: #{object.name}", "#{object.class}##{object.id}", !current_reward.nil? && current_reward.reward_to == object] :
        ["User: #{object.email} - #{object.username}", "#{object.class}##{object.id}", !current_reward.nil? && current_reward.reward_to == object]}
    gifts = []
    if achievement.mode_type == "BeachApiCore::GiftbitConfig"
      gifts = achievement.use_all_config_brands ? achievement.mode.giftbit_brands.pluck(:gift_name, :id) : achievement.giftbit_brands.pluck(:gift_name, :id)
      gifts = gifts.map {|gift| [gift[0], gift[1], !current_reward.nil? && gift[1] == current_reward.giftbit_brand_id]}
    end
    render json: {reward_to: reward_to, gifts: gifts}
  end

  action_item only: :show, priority: 1 do
    link_to('Resend Gift', admin_resend_gift_path(reward.gift_uuid), method: :put) if reward.achievement.mode_type == "BeachApiCore::GiftbitConfig" &&
        reward.gift_uuid.present? && reward.Fulfilled? && reward.shortlink.nil?
  end

  action_item only: :show, priority: 2 do
    link_to('Cancel Gift', admin_cancel_gift_path(reward.gift_uuid), method: :delete) if reward.achievement.mode_type == "BeachApiCore::GiftbitConfig" &&
        reward.gift_uuid.present? && reward.Fulfilled?
  end

  action_item only: :index, priority: 0 do
    link_to('Run Worker', admin_run_reward_worker_path)
  end


  index do
    id_column
    column :achievement do |reward|
      reward.achievement.achievement_name
    end
    column :confirmed
    column :status
    column :reward_to do |reward|
      reward.reward_to_type == "BeachApiCore::User" ? link_to("User: #{reward.reward_to.username}", admin_user_path( reward.reward_to)) : link_to("Device: #{reward.reward_to.name}", admin_device_path(reward.reward_to))
    end
    column :reward_mode do |reward|
      reward_mode(reward.achievement.mode_type)
    end
    column :created_at, label: "Last Reward Request"
    actions
  end


  form do |f|
    f.inputs "Reward Details", class: 'inputs js-reward_to js-reward_to_wrapper' do
      f.semantic_errors *f.object.errors.keys
      if f.object.new_record?
        f.input :achievement, collection: BeachApiCore::Achievement.all.map {|achievement| ["#{achievement.application.name} - #{achievement.achievement_name}", achievement.id]}
        f.input :reward_to_type, as: :hidden, input_html: { class: 'js-reward_to_type' }
        f.input :reward_to_id, as: :hidden, input_html: { class: 'js-reward_to_id' }
        f.input :reward_to, as: :select,
                collection: [],
                input_html: { class: 'js-reward_to_select', name: :reward_to }
        f.input :giftbit_brand
      else
        f.input :achievement, collection: BeachApiCore::Achievement.all.map {|achievement| ["#{achievement.application.name} - #{achievement.achievement_name}", achievement.id]}, input_html: {disabled: true}
        f.input :reward_to_type, as: :hidden, input_html: { class: 'js-reward_to_type', disabled: true }
        f.input :reward_to_id, as: :hidden, input_html: { class: 'js-reward_to_id', disabled: true }
        f.input :reward_to, as: :select,
                collection: [],
                input_html: { class: 'js-reward_to_select', name: :reward_to, disabled: true }
        f.input :giftbit_brand, input_html: {disabled: true}
      end

      f.input :confirmed
    end
    f.actions
  end

  show do |reward|
    attributes_table do
      row :achievement
      row :status
      row :reward_mode do
        reward_mode(reward.achievement.mode_type)
      end
      row :reward_to do
        reward_to = reward.reward_to_type.demodulize == 'User' ? link_to(reward.reward_to.username, admin_user_path(reward.reward_to_id), method: :get) : link_to(reward.reward_to.name, admin_device_path(reward.reward_to_id))
      end
      row :confirmed do |reward|
        reward.confirmed ? reward.confirmed : link_to('Confirm', admin_reward_path(reward, reward: { confirmed: true }), method: :put, class: 'button')
      end
      if reward_mode(reward.achievement.mode_type) == 'GiftBit'
        row :awarded_gift_name do
          BeachApiCore::GiftbitBrand.find(reward.giftbit_brand_id).gift_name
        end
      end
      unless reward.gift_uuid.nil?
        row :gift_uuid
      end
      unless reward.shortlink.nil?
        row :shortlink
      end
    end

  end

  controller do
    def resend_gift
      token =  @reward.achievement.mode.giftbit_token.blank? ? ENV['GIFTBIT_TOKEN'] : @reward.achievement.mode.giftbit_token.blank?
      result = BeachApiCore::GiftbitHelper.resend_gift(token, @reward.gift_uuid)
      redirect_after_updating_gift result
    end

    def cancel_gift
      token =  @reward.achievement.mode.giftbit_token.blank? ? ENV['GIFTBIT_TOKEN'] : @reward.achievement.mode.giftbit_token.blank?
      result = BeachApiCore::GiftbitHelper.cancel_gift(token, @reward.gift_uuid)
      redirect_after_updating_gift result
    end

    def run_create_campaign_worker
      BeachApiCore::GiftbitRewardWorker.perform_async(true)
      flash[:notice] = 'Worker successfully launched'
      redirect_to admin_rewards_path
    end

    private

    def set_reward
      @reward = BeachApiCore::Reward.find_by(gift_uuid: params[:uuid])
    end

    def redirect_after_updating_gift result
      result['status'] == 422 || result['status'] == 400 ? (flash[:error] = result['info']['message']) :
          (flash[:notice] = result['info']['message'])
      redirect_to admin_reward_path(@reward)
    end

    def update_status
      reward = BeachApiCore::Reward.find(params[:id])
      if reward.achievement.mode_type == "BeachApiCore::GiftbitConfig" && reward.status == 'Fulfilled' && !reward.gift_uuid.nil?
        token =  reward.achievement.mode.giftbit_token.blank? ? ENV['GIFTBIT_TOKEN'] : reward.achievement.mode.giftbit_token
        status = BeachApiCore::GiftbitHelper.gift_status(token, reward.gift_uuid)
        reward.update_status status
      end
    end
  end
end
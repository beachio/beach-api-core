ActiveAdmin.register BeachApiCore::Achievement, as: 'Achievement' do
  menu priority: 66, parent: 'Achievements and Rewards'

  permit_params :achievement_name, :points_required, :max_rewards, :reward_expiry, :reward_issue_requires_approval, :notify_by_email,
                :notify_via_broadcasts, :application_id, :mode_id, :available_for, :use_all_config_brands, :mode_type, giftbit_brand_ids: []

  collection_action :get_configs, method: :get do
    active_config = BeachApiCore::Achievement.find_by(id: params[:achievement_id]) if !params[:achievement_id].nil?
    modes = BeachApiCore::GiftbitConfig.where(application_id: params[:application_id]).to_a.concat(BeachApiCore::WebhookConfig.where(application_id: params[:application_id]))
    mode_configs = modes.map do |mode|
      active_mode = active_config.nil? ?  false  : mode.class.to_s == active_config.mode_type && mode.id == active_config.mode_id
      if mode.class.to_s == "BeachApiCore::GiftbitConfig"
        mode_name = "GiftBit - #{mode.config_name}"
      elsif mode.class.to_s == "BeachApiCore::WebhookConfig"
        mode_name = "Webhook - #{mode.config_name}"
      end
        active_mode ? [mode_name, "#{mode.class}##{mode.id}", true]  : [mode_name, "#{mode.class}##{mode.id}"]

    end
    render json: {configs: mode_configs}
  end

  collection_action :get_brands, method: :get do
    active_brands = BeachApiCore::Achievement.find_by(id: params[:achievement_id]).giftbit_brands.pluck(:id) if !params[:achievement_id].nil?
    brands = BeachApiCore::GiftbitBrand.where(giftbit_config_id: params[:giftbit_config_id]).pluck(:gift_name, :id)
    render json: {brands: brands.map {|brand| !active_brands.nil? && active_brands.include?(brand[1]) ? brand << true : brand}}
  end

  index do
    id_column
    column :application
    column :achievement_name
    column :points_required
    column :max_rewards
    column :available_for
    column :reward_mode do |achievement|
      reward_mode(achievement.mode_type)
    end
    actions
  end

  form do |f|
    f.inputs "Achievement Details", class: 'inputs js-modes js-mode_wrapper' do
      f.semantic_errors *f.object.errors.keys
      f.input :achievement_name
      if f.object.new_record?
        f.input :application
        f.input :points_required
        f.input :mode_type, as: :hidden, input_html: { class: 'js-mode_type' }
        f.input :mode_id, as: :hidden, input_html: { class: 'js-mode_id' }
        f.input :mode, as: :select, label: "Reward Mode",
                collection: [],
                input_html: { class: 'js-mode_select', name: :mode }
      else
        f.input :application, input_html: {disabled: true}
        f.input :points_required, input_html: {disabled: true}
        f.input :mode_type, as: :hidden, input_html: { class: 'js-mode_type', disabled: true }
        f.input :mode_id, as: :hidden, input_html: { class: 'js-mode_id', disabled: true }
        f.input :mode, as: :select,
                collection: [],
                input_html: { class: 'js-mode_select', name: :mode, disabled: true }
      end
      f.input :max_rewards
      f.input :available_for
      f.input :reward_expiry, label: "Reward expire in"
      f.input :reward_issue_requires_approval, label: "Requires Approval"
      f.input :notify_by_email
      f.input :notify_via_broadcasts
      f.input :use_all_config_brands
      f.input :giftbit_brands
    end
    f.actions
  end

  show do |achievement|
    attributes_table do
      row :application
      row :achievement_name
      row :points_required
      row :max_rewards
      row :available_for
      row :reward_expiry, label: "Reward expire in"
      row :reward_issue_requires_approval
      row :notify_by_email
      row :mode
      row :notify_via_broadcasts
      row :reward_mode do
        reward_mode(achievement.mode_type)
      end
      if reward_mode(achievement.mode_type) == "GiftBit"
        row :brands do
          if achievement.use_all_config_brands
            achievement.mode.giftbit_brands.pluck(:gift_name).join(", ")
          else
            safe_join(achievement.giftbit_brands.map do |option|
              "#{option.gift_name}"
            end, ', ')
          end
        end
      end
    end
  end

  controller do
    def scoped_collection
      super.includes(:application)
    end
  end
end
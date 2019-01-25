module BeachApiCore
  class GiftbitRewardWorker
    include Sidekiq::Worker

    def perform(admin_page=false)
      campaign_id = "#{ENV['RAILS_ENV']}_giftbit_rewards_"
      giftbit_achievement_ids = BeachApiCore::Reward.where("achievement_id in (?) and status = (?) and campaign_uuid IS NULL", BeachApiCore::Achievement.giftbit, 0).pluck(:achievement_id)
      giftbit_profiles = BeachApiCore::Achievement.where("id in (?)", giftbit_achievement_ids).pluck(:mode_id).uniq
      BeachApiCore::GiftbitConfig.where("id in (?)", giftbit_profiles).each do |profile|
        profile_api_key = profile.giftbit_token.blank? ? ENV['GIFTBIT_TOKEN'] : profile.giftbit_token
        if api_key_is_valid?(profile_api_key)
          profile_balance = BeachApiCore::GiftbitHelper.get_current_balance(profile_api_key)
          profile.rewards.pending.where(campaign_uuid: nil).group_by{|reward| reward.giftbit_brand_id}.each do |grouped_reward|
            brand = BeachApiCore::GiftbitBrand.find(grouped_reward[0])
            if profile_balance < brand.amount * grouped_reward[1].count
              notify_admin(profile)
              break
            else
              group_for_campaign = grouped_reward[1].group_by {|reward| [reward.achievement.reward_expiry, reward.reward_to_type == 'BeachApiCore::User' && reward.achievement.notify_by_email]}
              group_for_campaign.each do |achievement_expiry_email, list_rewards|
                contacts =  achievement_expiry_email[1] ? list_rewards.map { |reward| { email: reward.reward_to.email }} : nil
                links_count = !achievement_expiry_email[1] ? list_rewards.count : nil
                mail_config = {
                    email_template: brand.giftbit_email_template,
                    email_body: brand.email_body,
                    email_subject: brand.email_subject
                }
                result = BeachApiCore::GiftbitHelper.create_campaign(profile_api_key, contacts, links_count, campaign_id + list_rewards.pluck(:id).join('_'),
                                                                                   brand.amount, brand.brand_code, achievement_expiry_email[0], achievement_expiry_email[1], mail_config)
                if result["error"].blank?
                  campaign_uuid = result['campaign']["uuid"]
                  list_rewards.each do |reward|
                    reward.update_attribute(:campaign_uuid, campaign_uuid)
                  end
                else
                  notify_admin(profile, result["error"])
                end
              end
            end
          end
        else
          profile.rewards.update_all(:status => 2, :return_user_points => true)
        end
      end
      update_rewards_status
      BeachApiCore::UpdateGiftbitStatusWorker.perform_in(60.seconds.from_now)
      GiftbitRewardWorker.perform_in(24.hours.from_now) unless admin_page
    end

    private

    def notify_admin(profile, error = nil)
      error.nil? ? GiftbitMailer.not_enough_balance(profile).deliver_later : GiftbitMailer.campaign_creation_error(profile, error).deliver_later
    end

    def update_rewards_status
      rewards = BeachApiCore::Reward.where("achievement_id in (?) and status = (?) and gift_uuid IS NOT NULL", BeachApiCore::Achievement.giftbit, 1)
      rewards.each do |reward|
        token =  reward.achievement.mode.giftbit_token.blank? ? ENV['GIFTBIT_TOKEN'] : reward.achievement.mode.giftbit_token
        status = BeachApiCore::GiftbitHelper.gift_status(token, reward.gift_uuid)
        reward.update_status status
      end
    end

    def api_key_is_valid?(api_key)
      api_key = api_key.blank? ? ENV['GIFTBIT_TOKEN'] : api_key
      url = ENV['USE_TESTBET'] == 'true' ? "https://api-testbed.giftbit.com/papi/v1/ping" : "https://api.giftbit.com/papi/v1/ping"
      uri = URI.parse(url)
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "Bearer #{api_key}"
      res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
        http.request(req)
      }
      body = JSON.parse(res.body)
      body["error"].nil?
    end
  end
end
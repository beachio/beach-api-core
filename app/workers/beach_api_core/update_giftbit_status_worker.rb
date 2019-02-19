module BeachApiCore
  class UpdateGiftbitStatusWorker
    include Sidekiq::Worker

    def perform
      rewards_pending_campaign = BeachApiCore::Reward.pending.where.not(campaign_uuid: nil)
      rewards_pending_campaign.group_by{|reward| reward.campaign_uuid}.each do |campaign_rewards|
        profile = campaign_rewards[1].first.achievement.mode
        api_key = profile.giftbit_token.blank? ? ENV["GIFTBIT_TOKEN"] : profile.giftbit_token
        campaign_info = BeachApiCore::GiftbitHelper.get_gifts(api_key, nil, campaign_rewards[0])
        if campaign_info.blank? || campaign_info[:emails].blank? && campaign_info[:shortlinks].blank?
          UpdateGiftbitStatusWorker.perform_in(10.seconds.from_now)
          break
        else
          campaign_info[:email_mode] ? email_rewards(campaign_info[:emails], campaign_rewards[1]) : shortlink_rewards(campaign_info[:shortlinks], campaign_rewards[0])
        end
      end
    end

    private

    def send_via_broadcast reward
      reward.send_broadcast
    end

    def email_rewards(email_list, campaign_rewards)
      campaign_rewards.each do |reward|
        reward.update_attributes(:gift_uuid => email_list[reward.reward_to.email].delete(email_list[reward.reward_to.email].first)[:uuid], status: 1)
      end
    end

    def shortlink_rewards(shortlink_list, campaign_uuid)
      rewards = BeachApiCore::Reward.where(:campaign_uuid => campaign_uuid, shortlink: nil, status: 0 )
      rewards.each do |reward|
        reward.update_attributes(:shortlink => shortlink_list.first[0], status: 1, gift_uuid: shortlink_list.first[1] )
        shortlink_list.delete(shortlink_list.first)
      end
    end
  end
end
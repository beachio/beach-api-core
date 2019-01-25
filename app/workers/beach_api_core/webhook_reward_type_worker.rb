module BeachApiCore
  class WebhookRewardTypeWorker
    include Sidekiq::Worker

    def perform(reward_id, count = 0)
      reward = BeachApiCore::Reward.find_by(id: reward_id)
      unless reward.blank?
        config = reward.achievement.mode
        result = send_webhook(config,reward.reward_to)
        if result
          reward.update_attribute(:status, 3)
          reward.send_broadcast if reward.achievement.notify_via_broadcasts
          reward.send_email_notification("webhook")
        else
          if count >= 10
            reward.status = 2
            reward.return_user_points = true
            reward.save
          else
            BeachApiCore::WebhookRewardTypeWorker.perform_in(15.minutes.from_now, reward.id, count + 1)
          end
        end
      end
    end

    private
    def send_webhook(webhook_config, object)
      body_params =  webhook_config.request_method == "GET" || webhook_config.request_body.nil? && webhook_config.request_body.empty? ? "{}" : webhook_config.request_body
      webhook_params = webhook_config.webhook_parametrs.map do |webhook_param|
        value = object
        if !webhook_param[:value].nil? && webhook_param[:value].match?(/\[object\]/)
          webhook_param[:value].split(".").drop(1).each do |val|
            value = value[val] unless value.nil?
          end
        else
          value = webhook_param[:value]
        end
        "#{webhook_param[:name]}=#{value}" unless value.nil?
      end.join("&")
      full_url = webhook_params.empty? ? webhook_config.uri : "#{webhook_config.uri}?#{webhook_params}"
      uri = URI.parse(full_url)
      if webhook_config.request_method == "GET"
        req = Net::HTTP::Get.new(uri)
      elsif webhook_config.request_method == "POST"
        req = Net::HTTP::Post.new(uri)
      elsif webhook_config.request_method == "PUT"
        req = Net::HTTP::Put.new(uri)
      else
        req = Net::HTTP::Delete.new(uri)
      end
      req['Content-Type'] = 'application/json' if webhook_config.request_method != "GET"
      begin
        res = Net::HTTP.start(uri.host, uri.port, use_ssl: webhook_config.uri.match?(/\Ahttps:\/\//) ) do |http|
          req.body = body_params.to_json if webhook_config.request_method != "GET" && !webhook_config.request_body.nil? && !webhook_config.request_body.empty?
          http.read_timeout = 20
          http.request(req)
        end
        res.code == '200' && res.body == '1'
      rescue => e
        false
      end
    end
  end
end

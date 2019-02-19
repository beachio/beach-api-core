module BeachApiCore::Admin::ApplicationHelper
  def keepers
    keepers = Doorkeeper::Application.all.to_a.concat(BeachApiCore::Organisation.all)
    keepers.push(BeachApiCore::Instance.current)
    keepers.map { |keeper| [keeper_name(keeper), "#{keeper.class}##{keeper.id}"] }
  end

  def keepers_and_team_keepers
    keepers = Doorkeeper::Application.all.to_a.concat(BeachApiCore::Organisation.all).concat(BeachApiCore::Team.all)
    keepers.push(BeachApiCore::Instance.current)
    keepers.map { |keeper| [keeper_name(keeper), "#{keeper.class}##{keeper.id}"] }
  end

  def webhooks_keeper
    keepers = Doorkeeper::Application.all.to_a
    keepers.push(BeachApiCore::Instance.current)
    keepers.map { |keeper| [keeper_name(keeper), "#{keeper.class}##{keeper.id}"] }
  end

  def keeper_name(keeper)
    case keeper.class.to_s
    when 'BeachApiCore::Instance' then 'Current Instance'
    else
      keeper.class.to_s =~ /(.+)::(.+)/
      "#{Regexp.last_match(2)} - #{keeper.name} (#{keeper.id})"
    end
  end

  def reward_mode(reward_class)
    if reward_class == "BeachApiCore::GiftbitConfig"
      "GiftBit"
    elsif reward_class == "BeachApiCore::WebhookConfig"
      "Webhook"
    end
  end

  def giftbit_brand_list(admin = false)
    api = ENV['USE_TESTBET'] == 'true' ? "https://api-testbed.giftbit.com/papi/v1/brands?region=2&limit=500" : "https://api.giftbit.com/papi/v1/brands?region=2&limit=500"
    uri = URI.parse(api)
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{ENV['GIFTBIT_TOKEN']}"
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(req)
    }
    body = JSON.parse(res.body)
    if admin
      brands = []
      body['brands'].each do |brand|
        brands << ["#{brand['name']} - #{brand['brand_code']}", brand['brand_code']]
      end
      brands
    else
      body
    end
  end

  def value_for_user(user, field)
    BeachApiCore::ProfileAttribute.find_by(profile: user.profile, profile_custom_field: field)&.value || ''
  end

  def status_options(status)
    %w(Yes No Unsure).inject([]) do |acc, elem|
      option = [elem, elem]
      option << { checked: 'checked' } if elem == status
      acc << option
    end
  end
end

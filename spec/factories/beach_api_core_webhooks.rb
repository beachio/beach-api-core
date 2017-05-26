FactoryGirl.define do
  factory :webhook, class: 'BeachApiCore::Webhook' do
    uri Faker::Internet.url
    kind BeachApiCore::Webhook.kinds.keys.first
    application { build :oauth_application }
  end
end

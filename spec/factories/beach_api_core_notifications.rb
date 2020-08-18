FactoryBot.define do
  factory :beach_api_core_notifications, class: 'BeachApiCore::Notifications' do
    user { build :user }
    text { "Notification string" }
    kind { 0 }
    sent { true }
  end
end

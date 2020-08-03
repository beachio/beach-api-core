FactoryBot.define do
  factory :beach_api_core_activity, class: 'BeachApiCore::Activity' do
    user { build :user }
    kind { 0 }
  end
end

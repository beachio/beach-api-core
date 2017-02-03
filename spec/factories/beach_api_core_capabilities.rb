FactoryGirl.define do
  factory :beach_api_core_capability, class: 'BeachApiCore::Capability' do
    service { build :service }
    application { build :oauth_application }
  end
end

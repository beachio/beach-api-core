FactoryGirl.define do
  factory :capability, class: 'BeachApiCore::Capability' do
    service { build :service }
    application { build :oauth_application }
  end
end

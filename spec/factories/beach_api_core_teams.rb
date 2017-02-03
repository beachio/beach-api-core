FactoryGirl.define do
  factory :beach_api_core_team, class: 'BeachApiCore::Team' do
    name { Faker::Name.title }
    application { build :oauth_application }
  end
end

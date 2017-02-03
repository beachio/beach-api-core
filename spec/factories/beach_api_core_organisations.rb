FactoryGirl.define do
  factory :beach_api_core_organisation, class: 'BeachApiCore::Organisation' do
    name { Faker::Name.title }
    application { build :oauth_application }
  end
end

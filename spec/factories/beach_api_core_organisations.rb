FactoryGirl.define do
  factory :organisation, class: 'BeachApiCore::Organisation' do
    name { Faker::Name.title }
    application { build :oauth_application }
  end
end

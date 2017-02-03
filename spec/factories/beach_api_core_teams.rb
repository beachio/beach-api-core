FactoryGirl.define do
  factory :team, class: 'BeachApiCore::Team' do
    name { Faker::Name.title }
    application { build :oauth_application }
  end
end

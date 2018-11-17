FactoryBot.define do
  factory :organisation, class: 'BeachApiCore::Organisation' do
    name { Faker::Job.title }
    application { build :oauth_application }
  end
end

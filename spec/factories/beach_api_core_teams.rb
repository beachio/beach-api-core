FactoryGirl.define do
  factory :team, class: 'BeachApiCore::Team' do
    name { Faker::Name.title }
    application { build :oauth_application }

    trait :with_organisation do
      organisation { create(:organisation) }
    end
  end
end

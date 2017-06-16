FactoryGirl.define do
  factory :team, class: 'BeachApiCore::Team' do
    transient do
      with_application { build :oauth_application }
    end

    name { Faker::Name.title }
    application { with_application }

    trait :with_organisation do
      organisation { create(:organisation, application: with_application) }
    end
  end
end

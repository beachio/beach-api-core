FactoryGirl.define do
  factory :service, class: 'BeachApiCore::Service' do
    title { Faker::Name.title }
    description { Faker::Lorem.sentence }

    after(:build) do |service|
      service.service_category ||= build(:service_category)
    end

    trait :with_icon do
      icon { build(:asset) }
    end
  end
end

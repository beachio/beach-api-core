FactoryGirl.define do
  factory :beach_api_core_service_category, class: 'BeachApiCore::ServiceCategory' do
    name { Faker::Name.title }

    trait :with_services do
      after(:build) do |service_category|
        service_category.services << build_list(:service, 2, service_category: service_category)
      end
    end
  end
end

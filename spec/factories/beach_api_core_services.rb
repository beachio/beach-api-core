FactoryGirl.define do
  factory :beach_api_core_service, class: 'BeachApiCore::Service' do
    title { Faker::Name.title }

    after(:build) do |service|
      service.service_category ||= build(:service_category)
    end
  end
end

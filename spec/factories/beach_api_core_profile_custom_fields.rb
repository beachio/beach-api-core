FactoryGirl.define do
  factory :beach_api_core_profile_custom_field, class: 'BeachApiCore::ProfileCustomField' do
    keeper { build :instance }
    title { Faker::Name.title }
  end
end

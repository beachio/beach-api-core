FactoryGirl.define do
  factory :profile_custom_field, class: 'BeachApiCore::ProfileCustomField' do
    keeper { BeachApiCore::Instance.current }
    title { Faker::Name.title }
  end
end

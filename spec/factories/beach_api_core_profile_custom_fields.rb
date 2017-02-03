FactoryGirl.define do
  factory :profile_custom_field, class: 'BeachApiCore::ProfileCustomField' do
    keeper { build :instance }
    title { Faker::Name.title }
  end
end

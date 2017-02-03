FactoryGirl.define do
  factory :beach_api_core_profile_attribute, class: 'BeachApiCore::ProfileAttribute' do
    value { Faker::Name.title }

    after(:build) do |profile_attribute|
      profile_attribute.profile_custom_field ||= build(:profile_custom_field)
      profile_attribute.profile ||= build(:profile, profile_attributes: [profile_attribute])
    end
  end
end

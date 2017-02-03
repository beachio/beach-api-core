FactoryGirl.define do
  factory :beach_api_core_profile, class: 'BeachApiCore::Profile' do
    first_name          { Faker::Name.first_name }
    last_name           { Faker::Name.last_name }
    sex                 { %w(male female).sample }

    after(:build) do |profile|
      profile.user ||= build(:user, profile: profile)
    end
  end
end

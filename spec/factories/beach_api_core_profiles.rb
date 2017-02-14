FactoryGirl.define do
  factory :profile, class: 'BeachApiCore::Profile' do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    sex         { %w(male female).sample }
    birth_date  { Time.now - rand(50 * 365).days }

    after(:build) do |profile|
      profile.user ||= build(:user, profile: profile)
    end

    trait :with_avatar do
      avatar { build(:asset) }
    end
  end
end

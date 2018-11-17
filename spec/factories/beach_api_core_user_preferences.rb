FactoryBot.define do
  factory :user_preference, class: 'BeachApiCore::UserPreference' do
    user
    application { build :oauth_application }
    preferences { { text: Faker::Lorem.sentence } }
  end
end

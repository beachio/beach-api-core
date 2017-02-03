FactoryGirl.define do
  factory :beach_api_core_invitation, class: 'BeachApiCore::Invitation' do
    user { build :user }
    email { Faker::Internet.email }
    group { build :team }
  end
end

FactoryGirl.define do
  factory :invitation, class: 'BeachApiCore::Invitation' do
    user { build :user }
    email { Faker::Internet.email }
    group { create :team }
    roles { [create(:role)] }
  end
end

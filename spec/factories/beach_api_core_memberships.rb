FactoryGirl.define do
  factory :beach_api_core_membership, class: 'BeachApiCore::Membership' do
    member { build :user }
    group { build :team }
  end
end

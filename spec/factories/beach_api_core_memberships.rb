FactoryGirl.define do
  factory :membership, class: 'BeachApiCore::Membership' do
    member { build :user }
    group { build :team }
    # owner false
  end
end

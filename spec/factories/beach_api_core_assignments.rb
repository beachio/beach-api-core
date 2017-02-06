FactoryGirl.define do
  factory :assignment, class: 'BeachApiCore::Assignment' do
    keeper { build(:instance) }
    role
    user
  end
end

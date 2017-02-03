FactoryGirl.define do
  factory :assignment, class: 'BeachApiCore::Assignment' do
    role
    user
  end
end

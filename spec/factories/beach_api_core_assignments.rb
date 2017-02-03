FactoryGirl.define do
  factory :beach_api_core_assignment, class: 'BeachApiCore::Assignment' do
    role
    user
  end
end

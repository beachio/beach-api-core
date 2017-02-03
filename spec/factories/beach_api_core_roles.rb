FactoryGirl.define do
  factory :beach_api_core_role, class: 'BeachApiCore::Role' do
    keeper { build(:instance) }
    name { Faker::Lorem.word }
  end
end

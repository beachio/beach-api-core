FactoryGirl.define do
  factory :role, class: 'BeachApiCore::Role' do
    keeper { build(:instance) }
    name { Faker::Lorem.word }
  end
end

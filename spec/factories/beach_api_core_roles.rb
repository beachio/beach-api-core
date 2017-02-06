FactoryGirl.define do
  factory :role, class: 'BeachApiCore::Role' do
    name { Faker::Lorem.word }
  end
end

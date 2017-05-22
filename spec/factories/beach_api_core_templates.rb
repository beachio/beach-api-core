FactoryGirl.define do
  factory :template, class: 'BeachApiCore::Template' do
    name { Faker::Lorem.word }
    value { Faker::Lorem.sentence }
  end
end

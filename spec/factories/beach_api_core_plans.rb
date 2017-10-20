FactoryGirl.define do
  factory :plan, class: 'BeachApiCore::Plan' do
    name { Faker::Name.title }
  end
end

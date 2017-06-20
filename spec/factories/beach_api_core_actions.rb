FactoryGirl.define do
  factory :action, class: 'BeachApiCore::Action' do
    controller { build(:controller) }
    name { Faker::Lorem.word }
  end
end

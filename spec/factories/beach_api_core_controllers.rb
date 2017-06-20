FactoryGirl.define do
  factory :controller, class: 'BeachApiCore::Controller' do
    service { build(:service) }
    name { Faker::Lorem.word }
  end
end

FactoryGirl.define do
  factory :controllers_service, class: 'BeachApiCore::ControllersService' do
    service { build(:service) }
    name { Faker::Lorem.word }
  end
end

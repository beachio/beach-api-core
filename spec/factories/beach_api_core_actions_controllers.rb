FactoryGirl.define do
  factory :actions_controller, class: 'BeachApiCore::ActionsController' do
    controllers_service { build(:controllers_service) }
    name { Faker::Lorem.word }
  end
end

FactoryGirl.define do
  factory :beach_api_core_setting, aliases: [:setting], class: 'BeachApiCore::Setting' do
    key { Faker::Lorem.word }
    value { Faker::Lorem.word }
    keeper { build :instance }
  end
end

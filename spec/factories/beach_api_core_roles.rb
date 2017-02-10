FactoryGirl.define do
  factory :role, class: 'BeachApiCore::Role' do
    sequence(:name) {|n| "#{Faker::Lorem.word}_#{n}" }
  end
end

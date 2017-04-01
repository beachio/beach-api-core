FactoryGirl.define do
  factory :interaction_attribute, class: 'BeachApiCore::InteractionAttribute' do
    interaction
    sequence(:key) { |n| "#{Faker::Lorem.word}-#{n}" }
    values { { text: Faker::Lorem.sentence } }
  end
end

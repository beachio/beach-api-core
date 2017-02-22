FactoryGirl.define do
  factory :interaction_attribute, class: 'BeachApiCore::InteractionAttribute' do
    interaction
    key { Faker::Lorem.word }
    values { { text: Faker::Lorem.sentence } }
  end
end

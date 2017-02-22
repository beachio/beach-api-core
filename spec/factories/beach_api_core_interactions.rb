FactoryGirl.define do
  factory :interaction, class: 'BeachApiCore::Interaction' do
    user
    keeper { build(:instance) }
    kind { Faker::Lorem.word }
  end
end

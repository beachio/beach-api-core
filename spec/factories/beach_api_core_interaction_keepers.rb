FactoryGirl.define do
  factory :interaction_keeper, class: 'BeachApiCore::InteractionKeeper' do
    interaction
    keeper { build(:instance) }
  end
end

FactoryGirl.define do
  factory :interaction_keeper, class: 'BeachApiCore::InteractionKeeper' do
    interaction
    keeper { BeachApiCore::Instance.current }
  end
end

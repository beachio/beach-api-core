FactoryGirl.define do
  factory :interaction_keeper, class: 'BeachApiCore::InteractionKeeper' do
    keeper { BeachApiCore::Instance.current }

    after(:build) do |interaction_keeper|
      interaction_keeper.interaction = build(:interaction, interaction_keepers: [interaction_keeper])
    end
  end
end

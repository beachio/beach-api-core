FactoryGirl.define do
  factory :interaction, class: 'BeachApiCore::Interaction' do
    user
    kind { Faker::Lorem.word }

    after(:build) do |interaction|
      interaction.interaction_keepers << build(:interaction_keeper,
                                               interaction: interaction) if interaction.interaction_keepers.empty?
    end
  end
end

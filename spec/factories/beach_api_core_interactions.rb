FactoryBot.define do
  factory :interaction, class: 'BeachApiCore::Interaction' do
    user
    kind { Faker::Lorem.word }

    after(:build) do |interaction|
      if interaction.interaction_keepers.empty?
        interaction.interaction_keepers << build(:interaction_keeper,
                                                 interaction: interaction)
      end
    end
  end
end

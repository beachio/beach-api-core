require 'rails_helper'

module BeachApiCore
  RSpec.describe Interaction, type: :model do
    subject { build(:interaction) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :user
      should validate_presence_of :interaction_keepers
      should validate_presence_of :kind
    end

    it 'should have relations' do
      should belong_to :user
      should have_many :interaction_attributes
      should have_many :interaction_keepers
      should have_many :assets
      should accept_nested_attributes_for :interaction_attributes
      should accept_nested_attributes_for :assets
    end

    it 'should remove interaction attributes' do
      interaction = create :interaction
      interaction.interaction_attributes = create_list(:interaction_attribute, 2, interaction: interaction)
      expect { interaction.destroy }.to change(BeachApiCore::Interaction, :count)
                                            .and change(BeachApiCore::InteractionAttribute, :count)
    end

    it 'should not create interation with duplicated attributes keys' do
      interaction = build :interaction
      key = Faker::Lorem.word
      interaction.update(interaction_attributes_attributes: [{ key: key, values: { name: Faker::Lorem.word } },
                                                             { key: key, values: { name: Faker::Lorem.word } }])
      expect(interaction).to be_invalid
    end

    it 'should not update interation with duplicated attributes keys' do
      interaction = create :interaction
      key = Faker::Lorem.word
      interaction.update(interaction_attributes_attributes: [{ key: key, values: { name: Faker::Lorem.word } },
                                                             { key: key, values: { name: Faker::Lorem.word } }])
      expect(interaction).to be_invalid
    end

  end
end

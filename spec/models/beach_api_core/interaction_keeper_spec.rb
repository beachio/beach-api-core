require 'rails_helper'

module BeachApiCore
  RSpec.describe InteractionKeeper, type: :model do
    subject { build(:interaction_keeper) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      create :interaction_attribute
      should validate_presence_of :interaction
      should validate_presence_of :keeper
      should validate_uniqueness_of(:interaction).scoped_to(:keeper_id, :keeper_type)
    end
  end
end

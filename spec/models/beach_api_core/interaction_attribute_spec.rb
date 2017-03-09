require 'rails_helper'

module BeachApiCore
  RSpec.describe InteractionAttribute, type: :model do
    subject { build(:interaction_attribute) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      create :interaction_attribute
      should belong_to :interaction
      should validate_presence_of :interaction
      should validate_presence_of :key
      should validate_uniqueness_of(:interaction).scoped_to(:key)
    end
  end
end

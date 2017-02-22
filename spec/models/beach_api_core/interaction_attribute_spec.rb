require 'rails_helper'

module BeachApiCore
  RSpec.describe InteractionAttribute, type: :model do
    subject { build(:interaction_attribute) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should belong_to :interaction
      should validate_presence_of :key
    end
  end
end

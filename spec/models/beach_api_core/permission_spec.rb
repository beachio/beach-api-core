require 'rails_helper'

module BeachApiCore
  RSpec.describe Permission, type: :model do
    subject { build(:permission) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations and basic validations' do
      should validate_presence_of :atom
      should validate_presence_of :keeper
      should allow_value('', nil).for(:actions)
      should validate_inclusion_of(:keeper_type).in_array(%w(BeachApiCore::Role BeachApiCore::Team BeachApiCore::User))
    end

    it 'should have uniqueness' do
      create :permission
      should validate_uniqueness_of(:atom).scoped_to(:keeper_id, :keeper_type)
    end

  end
end

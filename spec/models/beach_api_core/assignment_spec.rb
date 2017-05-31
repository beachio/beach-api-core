require 'rails_helper'

module BeachApiCore
  describe Assignment, type: :model do
    subject { build :assignment }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations' do
      should belong_to :keeper
    end

    it 'should have basic validations' do
      should validate_presence_of :user
      should validate_presence_of :role
      should validate_presence_of :keeper
    end

    it 'should have uniqueness' do
      create :assignment
      should validate_uniqueness_of(:user).scoped_to(:role_id, :keeper_id, :keeper_type)
    end
  end
end

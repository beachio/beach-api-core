require 'rails_helper'

module BeachApiCore
  describe Assignment, type: :model do
    subject { build(:assignment) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :user
      should validate_presence_of :role
    end
    it 'should have uniqueness' do
      create :role
      should validate_uniqueness_of(:user).scoped_to(:role_id)
    end
  end
end

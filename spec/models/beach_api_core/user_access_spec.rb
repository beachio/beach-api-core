require 'rails_helper'

module BeachApiCore
  describe UserAccess, type: :model do
    subject { build :user_access }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations' do
      should belong_to :keeper
    end

    it 'should have basic validations' do
      should validate_presence_of :user
      should validate_presence_of :access_level
      should validate_presence_of :keeper
    end
  end
end

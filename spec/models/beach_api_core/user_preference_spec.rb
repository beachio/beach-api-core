require 'rails_helper'

module BeachApiCore
  describe UserPreference, type: :model do
    subject { build :user_preference }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations' do
      should belong_to :user
      should belong_to :application
    end

    it 'should have basic validations' do
      should validate_presence_of :user
      should validate_presence_of :application
      should validate_presence_of :preferences
    end
  end
end

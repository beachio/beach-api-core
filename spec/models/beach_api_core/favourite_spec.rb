require 'rails_helper'

module BeachApiCore
  describe Favourite, type: :model do
    subject { build(:favourite) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end
    it 'should have basic validations' do
      should validate_presence_of :user
      should validate_presence_of :favouritable
    end
    it 'should have uniqueness' do
      create :favourite
      should validate_uniqueness_of(:user).scoped_to(%i(favouritable_id favouritable_type))
    end
  end
end

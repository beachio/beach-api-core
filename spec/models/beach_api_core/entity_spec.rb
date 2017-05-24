require 'rails_helper'

module BeachApiCore
  RSpec.describe Entity, type: :model do
    subject { build(:entity) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end
    it 'should have basic validations' do
      should validate_presence_of :user
      should validate_presence_of :uid
      should validate_presence_of :kind
    end
    it 'should have uniqueness' do
      create :entity
      should validate_uniqueness_of(:kind).scoped_to(:uid)
    end
  end
end

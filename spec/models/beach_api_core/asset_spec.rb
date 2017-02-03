require 'rails_helper'

module BeachApiCore
  describe Asset, type: :model do
    subject { build(:asset) }

    it 'should be valid with basic factory attributes' do
      expect(build(:asset)).to be_valid
    end

    it 'should have basic validations' do
      should belong_to :entity
      should validate_presence_of :file
      should validate_presence_of :entity
    end
  end
end

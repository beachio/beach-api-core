require 'rails_helper'

module BeachApiCore
  describe Capability, type: :model do
    subject { build(:capability) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should belong_to :service
      should belong_to :application
      should validate_presence_of :service
      should validate_presence_of :application
    end
  end
end

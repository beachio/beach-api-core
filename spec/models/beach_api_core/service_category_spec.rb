require 'rails_helper'

module BeachApiCore
  describe ServiceCategory, type: :model do
    subject { build(:service_category) }

    it 'should have basic validations' do
      expect(subject).to be_valid
    end

    it 'should have basic validations and associations' do
      should validate_presence_of :name
      should have_many(:services)
    end
  end
end

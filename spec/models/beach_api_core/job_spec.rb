require 'rails_helper'

module BeachApiCore
  describe Job, type: :model do
    subject { build :job }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :start_at
    end
  end
end

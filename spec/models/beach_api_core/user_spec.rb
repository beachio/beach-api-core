require 'rails_helper'

module BeachApiCore
  describe User, type: :model do
    subject { build(:user) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end
  end
end

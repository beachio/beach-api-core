require 'rails_helper'

module BeachApiCore
  describe Invitation, type: :model do
    subject { build(:invitation) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should belong_to :user
      should belong_to :group
      should validate_presence_of :email
      should validate_presence_of :user
      should validate_presence_of :group
    end
  end
end

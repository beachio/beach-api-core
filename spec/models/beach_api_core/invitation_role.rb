require 'rails_helper'

module BeachApiCore
  RSpec.describe InvitationRole, type: :model do
    subject { build :invitation_role }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :invitation
      should validate_presence_of :role
      should validate_uniqueness_of(:role).scoped_to(:invitation)
    end
  end
end

require 'rails_helper'

module BeachApiCore
  RSpec.describe InvitationToken, type: :model do
    subject { create :invitation_token }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations' do
      should belong_to :user
      should belong_to :entity
    end

    it 'should have basic validations' do
      should validate_presence_of :user
      should validate_presence_of :entity
    end

    it 'should generate random url safe token on save' do
      invitation_token = create(:invitation_token, token: nil)
      expect(invitation_token.token).to be_present
    end

    it 'should define expire_at' do
      invitation_token = create(:invitation_token)
      expect(invitation_token.expire_at).to be_present
    end
  end
end

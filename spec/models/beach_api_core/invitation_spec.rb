require 'rails_helper'

module BeachApiCore
  describe Invitation, type: :model do
    subject { build(:invitation) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should belong_to :user
      should belong_to :invitee
      should belong_to :group
      should validate_presence_of :email
      should validate_presence_of :user
      should validate_presence_of :group
    end

    it 'should validate invitee' do
      invitation = build :invitation, email: ''
      expect(invitation).to be_invalid
      expect(invitation.errors.messages).to include(:'invitee.email')
    end

    it 'should initialize an invitee on create' do
      invitation = build :invitation, user: (create :user), group: (create :team)
      expect { invitation.save }.to change(User, :count).by(1)
      expect(User.last.email).to eq(invitation.email)
    end

    context 'when user with invitation email is present' do
      it 'should attach user to invitation' do
        invitee = create :user
        invitation = build :invitation,
                           email: invitee.email,
                           user: (create :user),
                           group: (create :team)
        expect { invitation.save }.not_to change(User, :count)
        expect(invitation.invitee.id).to eq invitee.id
      end
    end
  end
end

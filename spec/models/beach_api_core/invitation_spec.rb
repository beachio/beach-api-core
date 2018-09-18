require 'rails_helper'

module BeachApiCore
  describe Invitation, type: :model do
    subject  do
      invitation = build :invitation
      create(:setting, keeper: invitation.group.application, name: "noreply_from", value: "test1@test.com")
      create(:setting, keeper: invitation.group.application, name: "client_domain", value: "https://test1.com")
      invitation.user = invitation.group.application.owner
      create :membership, member: invitation.user, group: invitation.group
      invitation.application = invitation.group.application
      invitation.save
      invitation
    end

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations' do
      should belong_to :user
      should belong_to :invitee
      should belong_to :group
      should have_many :roles
    end

    it 'should have basic validations' do
      should validate_presence_of :email
      should validate_presence_of :user
      should validate_presence_of :group
      should validate_presence_of :roles
      should validate_uniqueness_of :token
    end

    it 'should validate invitee' do
      invitation = build :invitation, email: ''
      expect(invitation).to be_invalid
      expect(invitation.errors.messages).to include(:'invitee.email')
    end

    it 'should initialize an invitee on create' do
      invitation = build :invitation, user: (create :user), group: (create :team)
      create(:setting, keeper: invitation.group.application, name: "noreply_from", value: "test1@test.com")
      create(:setting, keeper: invitation.group.application, name: "client_domain", value: "https://test1.com")
      invitation.user = invitation.group.application.owner
      create :membership, member: invitation.user, group: invitation.group
      invitation.application = invitation.group.application
      expect { invitation.save }.to change(User, :count).by(1)
      expect(User.last.email).to eq(invitation.email)
    end

    it 'should generate random url safe token on save' do
      invitation = build :invitation, token: nil
      create(:setting, keeper: invitation.group, name: "reply_from", value: "test1@test.com")
      create(:setting, keeper: invitation.group, name: "client_domain", value: "https://test1.com")
      invitation.save
      expect(invitation.token).to be_present
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

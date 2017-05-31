require 'rails_helper'

module BeachApiCore
  describe User, type: :model do
    subject { build(:user) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations' do
      should have_one(:profile).dependent(:destroy)
      should have_many(:assignments).dependent(:destroy)
      should have_many(:roles)
      should have_many(:applications)
      should have_many(:favourites).dependent(:destroy)
      should have_many(:user_preferences).dependent(:destroy)
      should have_many(:received_invitations).dependent(:destroy)
      should have_many(:invitations).dependent(:destroy)
      should have_many :organisations
      should have_many :teams
      should have_many :projects
      should respond_to :first_name
      should respond_to :last_name
    end

    it 'should have basic validations' do
      should validate_presence_of :email
      should validate_presence_of :username
      should validate_presence_of :status
      should define_enum_for(:status).with(active: 0, invitee: 1)
    end

    it 'should have uniqueness case insensitive' do
      create :user
      should validate_uniqueness_of(:email).case_insensitive
      should validate_uniqueness_of(:username).case_insensitive
    end

    it 'should build profile' do
      user = create :user
      expect(user.profile).to be_present
    end

    context 'when email format' do
      it 'should be invalid' do
        addresses = %w(user@foo,com user_at_foo.org example.user@foo. foo@g.c foo@go.c
                       foo@bar_baz.com foo@bar+baz.com foo@bar..com foo@.com)
        addresses.each do |invalid_address|
          expect(build(:user, email: invalid_address)).not_to be_valid
        end
      end

      it 'should be valid' do
        addresses = %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
        addresses.each do |valid_address|
          expect(build(:user, email: valid_address)).to be_valid
        end
      end
    end

    it 'should generate username from email' do
      user = create :user, email: 'user.email@example.com'
      expect(user.username).to eq 'user.email'
    end

    context 'when roles' do
      before do
        BeachApiCore::Instance.instance_variable_set('@_current', nil)
        @user = create(:user)
        @role = create(:assignment, user: @user, keeper: BeachApiCore::Instance.current).role
        @other_role = create(:assignment, user: @user, keeper: BeachApiCore::Instance.current).role
      end
      it { expect(@user.role?(@role)).to be_truthy }
      it { expect(@user.role?(create(:role))).to be_falsey }

      it 'should add role to user' do
        @user.add_role(@other_role)
        expect(@user.role?(@other_role)).to be_truthy
      end
    end

    context 'when permission' do
      before do
        @atom = create :atom
        @user = create :user
        @organisation = create :organisation
        create :membership, member: @user, group: @organisation
        @role1 = create(:assignment, user: @user, keeper: @organisation).role
        @role2 = create(:assignment, user: @user, keeper: BeachApiCore::Instance.current).role
        @team1 = create :team
        create :membership, group: @team1, member: @user
        @team2 = create :team
        create :membership, group: @team2, member: @user

        create :permission, atom: @atom, keeper: @user, actions: { create: true, read: false }
        create :permission, atom: @atom, keeper: @role1, actions: { read: true, create: false, execute: false }
        create :permission, atom: @atom, keeper: @role2, actions: { execute: true }
        create :permission, atom: @atom, keeper: @team1, actions: { update: true, delete: false }
        create :permission, atom: @atom, keeper: @team2, actions: { delete: true, update: false }
      end
      it 'for organisation keeper' do
        actions = { create: true, read: true, update: true, delete: true, execute: false }
        expect(@user.permissions_for(@atom, @organisation)).to eq actions
      end

      it 'for current instance keeper' do
        actions = { create: true, read: false, update: true, delete: true, execute: true }
        expect(@user.permissions_for(@atom)).to eq actions
      end
    end
  end
end

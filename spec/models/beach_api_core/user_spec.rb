require 'rails_helper'

module BeachApiCore
  describe User, type: :model do
    subject { build(:user) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations' do
      should have_one(:profile)
      should have_many(:assignments).dependent(:destroy)
      should have_many(:roles)
      should have_many(:applications)
      should have_many(:favourites).dependent(:destroy)
    end

    it 'should have basic validations' do
      should validate_presence_of :email
      should validate_presence_of :username
      should have_many :organisations
      should have_many :teams
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
        @role = create(:assignment, user: @user).role
        @other_role = create(:assignment, user: @user).role
      end
      it { expect(@user.has_role?(@role)).to be_truthy }
      it { expect(@user.has_role?(create(:role))).to be_falsey }

      it 'should add role to user' do
        @user.add_role(@other_role)
        expect(@user.has_role?(@other_role)).to be_truthy
      end
    end
  end
end

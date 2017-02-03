require 'rails_helper'

module BeachApiCore
  describe Role, type: :model do
    subject { build(:role) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations' do
      should belong_to(:keeper)
      should have_many(:assignments).dependent(:destroy)
    end
    it 'should have methods' do
      should respond_to(:admin?)
      should respond_to(:developer?)
      should respond_to(:user?)
    end
    it 'should have basic validations' do
      should validate_presence_of :name
      should validate_presence_of :keeper
    end
    it 'should have uniqueness case insensitive' do
      create :role
      should validate_uniqueness_of(:name).case_insensitive.scoped_to(:keeper_id, :keeper_type)
    end

    context 'when class methods' do
      before do
        [:admin, :developer, :user].each do |name|
          create :role, name: name, keeper: Instance.current
        end
      end
      it 'should return role instance' do
        [:admin, :developer, :user].each do |name|
          expect(Role.send(name)).to be_present
          expect(Role.send(name).send("#{name}?")).to be_truthy
        end
      end
    end

    it do
      role = create :role, name: :admin
      expect(role.admin?).to be_truthy
      expect(role.developer?).to be_falsey
      expect(role.user?).to be_falsey
    end
  end
end

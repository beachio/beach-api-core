require 'rails_helper'

module BeachApiCore
  RSpec.describe Setting, type: :model do
    subject { build(:setting) }

    it do
      should respond_to :name
      should respond_to :value

      should validate_presence_of :name
      should validate_presence_of :keeper
      should validate_presence_of :value
    end

    describe 'dynamic methods' do
      it 'should have method if name exists' do
        setting = create :setting, keeper: BeachApiCore::Instance.current
        expect(Setting.send(setting.name)).to eq setting.value
      end

      it "should return nil if name doesn't exist" do
        expect(Setting.send(Faker::Lorem.characters)).to be_nil
      end

      it "shouldn't be valid if name is not allowed" do
        setting = build :setting, name: 'name'
        expect(setting).not_to be_valid
      end
    end

    it 'should normalize name' do
      setting = create :setting, name: 'some   Name '
      expect(setting.name).to eq 'some_name'
    end
  end
end

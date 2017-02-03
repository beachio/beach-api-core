require 'rails_helper'

module BeachApiCore
  describe Instance, type: :model do
    subject { build(:instance) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :name
    end

    it 'should have uniqueness case insensitive' do
      create :instance
      should validate_uniqueness_of(:name).case_insensitive
    end

    it "shouldn't have more than one Instance record" do
      create :instance
      expect { create :instance }.to raise_error(ActiveRecord::RecordInvalid)
    end

    describe 'class methods' do
      before { BeachApiCore::Instance.instance_variable_set('@_current', nil) }

      it 'should generate current' do
        expect(Instance.current).to be_present
      end

      it 'should return current' do
        instance = create :instance
        expect(Instance.current).to eq instance
      end
    end
  end
end

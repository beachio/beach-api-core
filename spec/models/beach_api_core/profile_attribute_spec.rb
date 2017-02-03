require 'rails_helper'

module BeachApiCore
  describe ProfileAttribute, type: :model do
    subject { build(:profile_attribute) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :value
      should validate_uniqueness_of(:profile).scoped_to(:profile_custom_field_id)
    end
  end
end

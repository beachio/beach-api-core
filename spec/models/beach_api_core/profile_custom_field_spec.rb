require 'rails_helper'

module BeachApiCore
  describe ProfileCustomField, type: :model do
    subject { build(:profile_custom_field) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :title
      should define_enum_for(:status).with(enabled: 0, disabled: 1)
      should validate_uniqueness_of(:name).scoped_to([:keeper_id, :keeper_type])
    end

    it 'should generate name' do
      profile_custom_field = create :profile_custom_field, title: 'Birth  Date '
      expect(profile_custom_field.name).to eq 'birth_date'
    end
  end
end

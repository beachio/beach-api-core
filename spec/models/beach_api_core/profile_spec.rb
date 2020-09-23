require 'rails_helper'

module BeachApiCore
  describe Profile, type: :model do
    subject { build(:profile) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have notifications disabled by default' do
      expect(subject.notifications_enabled).to be_falsey
    end

    it 'should have relations' do
      should have_many(:profile_attributes).dependent(:destroy)
    end

    it 'should have basic validations' do
      should validate_uniqueness_of :user
      should have_many :profile_custom_fields
      should define_enum_for(:sex).with(male: 0, female: 1)
    end

    it 'should have a name' do
      profile = create(:profile)
      expect(profile.name).to eq "#{profile.first_name} #{profile.last_name}"
    end
  end
end

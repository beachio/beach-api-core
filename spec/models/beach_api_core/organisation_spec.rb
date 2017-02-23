require 'rails_helper'

module BeachApiCore
  describe Organisation, type: :model do
    subject { build(:organisation) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations and basic validations' do
      should validate_presence_of :name
      should validate_presence_of :application
      should belong_to :application
      should have_many :users
      should have_many :teams
      should have_many :invitations
      should have_one :logo_image
    end
  end
end

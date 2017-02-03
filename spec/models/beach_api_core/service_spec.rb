require 'rails_helper'

module BeachApiCore
  describe Service, type: :model do
    subject { build(:service) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations and associations' do
      should validate_presence_of :title
      should validate_presence_of :name
      should belong_to :service_category
      should have_one :icon
      should have_many :capabilities
    end

    it 'should generate name' do
      service = create :service, title: 'Manage Roles'
      expect(service.name).to eq 'manage_roles'
    end
  end
end

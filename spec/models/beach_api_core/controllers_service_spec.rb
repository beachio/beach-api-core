require 'rails_helper'

module BeachApiCore
  RSpec.describe ControllersService, type: :model do
    subject { build(:controllers_service) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end
    it 'should have basic validations' do
      should validate_presence_of :name
      should validate_presence_of :service
    end
  end
end

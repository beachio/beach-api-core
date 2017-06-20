require 'rails_helper'

module BeachApiCore
  RSpec.describe Action, type: :model do
    subject { build(:action) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end
    it 'should have basic validations' do
      should validate_presence_of :name
      should validate_presence_of :controller
    end
  end
end

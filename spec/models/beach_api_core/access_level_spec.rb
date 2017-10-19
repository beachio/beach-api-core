require 'rails_helper'

module BeachApiCore
  RSpec.describe AccessLevel, type: :model do
    subject { build(:access_level) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :title
    end

    it 'should have basic relations' do
      should have_many(:user_accesses).dependent(:destroy)
    end
  end
end

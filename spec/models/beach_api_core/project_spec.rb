require 'rails_helper'

module BeachApiCore
  RSpec.describe Project, type: :model do
    subject { build :project }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :name
      should validate_presence_of :user
    end

    it 'should have relations' do
      should belong_to :user
      should have_many :project_keepers
    end
  end
end

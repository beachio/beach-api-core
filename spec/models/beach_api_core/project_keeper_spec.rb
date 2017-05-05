require 'rails_helper'

module BeachApiCore
  RSpec.describe ProjectKeeper, type: :model do
    subject { create :project_keeper }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :project
      should validate_presence_of :keeper
      should validate_uniqueness_of(:project).scoped_to(:keeper_id, :keeper_type)
    end
  end
end

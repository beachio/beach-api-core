require 'rails_helper'

module BeachApiCore
  RSpec.describe Interaction, type: :model do
    subject { build(:interaction) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :user
      should validate_presence_of :keeper
      should validate_presence_of :kind
    end

    it 'should have relations' do
      should belong_to :user
      should belong_to :keeper
      should have_many :interaction_attributes
      should have_many :attachments
      should accept_nested_attributes_for :interaction_attributes
    end
  end
end

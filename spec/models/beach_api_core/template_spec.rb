require 'rails_helper'

module BeachApiCore
  describe Template, type: :model do
    subject { build :template }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
      exepct(subject.email?).to be_truthy
    end

    it 'should have basic validations' do
      should validate_presence_of :name
      should validate_presence_of :value
    end

    it 'should validate uniqueness of normalized name' do
      template = create :template
      another_template = build :template, name: template.name.upcase
      expect(another_template).to be_invalid
    end
  end
end

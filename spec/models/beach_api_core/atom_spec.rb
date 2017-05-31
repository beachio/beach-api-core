require 'rails_helper'

module BeachApiCore
  RSpec.describe Atom, type: :model do
    subject { build(:atom) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should belong_to :atom_parent
      should validate_presence_of :title
      should validate_presence_of :kind
      should validate_uniqueness_of :name
    end

    it 'atom could not be a parent if it a child' do
      parent = create(:atom)
      child = create(:atom, atom_parent: parent)
      sub_child = create(:atom, atom_parent: child)

      parent.assign_attributes(atom_parent: child)
      expect(parent).to be_invalid

      parent.assign_attributes(atom_parent: sub_child)
      expect(parent).to be_invalid
    end

    it 'should remove relations after destroy' do
      atom = create :atom
      create_list :permission, 2, atom: atom
      expect { atom.destroy }
        .to change(BeachApiCore::Atom, :count).by(-1)
                                              .and change(BeachApiCore::Permission, :count).by(-2)
    end
  end
end

module BeachApiCore
  class Atom < ApplicationRecord
    include Concerns::NameGenerator

    belongs_to :atom_parent, class_name: 'BeachApiCore::Atom', foreign_key: :atom_parent_id

    validates :name, presence: true, uniqueness: true
    validates :title, :kind, presence: true

    validate :check_looped_tree

    private

    def check_looped_tree(parent = nil, is_first = true)
      parent ||= atom_parent if is_first
      errors.add(:atom_parent_id, 'can not be a parent') and return if parent == self
      check_looped_tree(parent.atom_parent, false) if parent
    end
  end
end

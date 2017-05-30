module BeachApiCore
  class Atom < ApplicationRecord
    include Concerns::NameGenerator

    belongs_to :atom_parent, class_name: 'BeachApiCore::Atom', foreign_key: :atom_parent_id, optional: true
    has_many :permissions, class_name: 'BeachApiCore::Permission', inverse_of: :atom, dependent: :destroy

    validates :name, presence: true, uniqueness: true
    validates :title, :kind, presence: true

    validate :check_looped_tree

    scope :with_actions, (lambda do |actions|
      joins(:permissions).where(actions.map { |action| "actions -> '#{action}' = 'true'" }.join(' AND ')).distinct
    end)

    scope :for_user, (lambda do |user|
      sub_query = BeachApiCore::Permission.for_user(user, user.roles).select(:id)
      joins(:permissions).where.has { permissions.id.in sub_query }
    end)

    class << self
      def lookup!(name_or_id)
        atom = where.has { |a| (a.id == name_or_id) | (a.name == name_or_id) }.first
        raise ActiveRecord::RecordNotFound, I18n.t('errors.not_found') unless atom
        atom
      end
    end

    def atom_parent_id=(value)
      return if value.blank?
      self.atom_parent = BeachApiCore::Atom.lookup!(value)
      instance_variable_get(:@attributes)['atom_parent_id'].instance_variable_set(:@value, atom_parent.id)
    end

    private

    def check_looped_tree(parent = nil)
      parent ||= atom_parent
      return errors.add(:atom_parent_id, :can_not_be_a_parent) if parent == self
      check_looped_tree(parent.atom_parent) if parent&.atom_parent
    end
  end
end

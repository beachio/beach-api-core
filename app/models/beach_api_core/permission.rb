module BeachApiCore
  class Permission < ApplicationRecord
    belongs_to :atom, class_name: 'BeachApiCore::Atom'
    belongs_to :keeper, polymorphic: true

    validates :atom, :keeper, presence: true
    validates :actions, presence: true, allow_blank: true
    validates :atom, uniqueness: { scope: [:keeper_id, :keeper_type] }
    validates :keeper_type, inclusion: %w(BeachApiCore::Role BeachApiCore::Team BeachApiCore::User)
  end
end

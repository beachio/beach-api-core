module BeachApiCore
  class Permission < ApplicationRecord

    KEEPER_TYPES = %w(BeachApiCore::Role BeachApiCore::Organisation BeachApiCore::Team BeachApiCore::User)

    belongs_to :atom, class_name: 'BeachApiCore::Atom', inverse_of: :permissions
    belongs_to :keeper, polymorphic: true

    validates :atom, :keeper, presence: true
    validates :actions, presence: true, allow_blank: true
    validates :atom, uniqueness: { scope: [:keeper_id, :keeper_type] }
    validates :keeper_type, inclusion: KEEPER_TYPES

    %w(create read update delete execute).each do |action|
      define_method action do
        actions[action]
      end

      define_method "#{action}=" do |value|
        actions[action] = value
      end
    end

    def keeper_name
      return unless keeper
      "#{keeper.try(:email) || keeper.try(:name)} (#{keeper_type}, #{keeper_id})"
    end
  end
end

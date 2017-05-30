module BeachApiCore
  class Permission < ApplicationRecord
    KEEPER_TYPES = %w(BeachApiCore::Role BeachApiCore::Organisation BeachApiCore::Team BeachApiCore::User).freeze

    belongs_to :atom, class_name: 'BeachApiCore::Atom', inverse_of: :permissions
    belongs_to :keeper, polymorphic: true

    validates :atom, :keeper, :actor, presence: true
    validates :actions, presence: true, allow_blank: true
    validates :atom, uniqueness: { scope: %i(actor keeper_id keeper_type) }
    validates :keeper_type, inclusion: KEEPER_TYPES

    scope :for_user, ->(user, roles) { where(keeper: [user, user.organisations, user.teams, roles].compact.flatten) }

    def method_missing(name, *args, &block)
      super
    rescue NoMethodError
      raise unless name =~ %r{/action_(.+)/}
      return actions[Regexp.last_match[1]] unless Regexp.last_match[1].last == '='
      actions[Regexp.last_match[1][0..-2]] = args.first
    end

    def respond_to_missing?(method_name, include_private = false)
      super || method_name.match(%r{/action_(.+)/})
    end

    def keeper_name
      return unless keeper
      "#{keeper.try(:email) || keeper.try(:name)} (#{keeper_type}, #{keeper_id})"
    end
  end
end

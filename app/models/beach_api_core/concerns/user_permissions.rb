module BeachApiCore::Concerns::UserPermissions
  extend ActiveSupport::Concern

  included do
    def permissions_for(atom, keeper = nil)
      user_roles = roles.where.has{ assignments.keeper == (keeper || BeachApiCore::Instance.current) }
      permissions = atom.permissions.for_user(self, user_roles).pluck(:actions)
      keys = permissions.map(&:keys).flatten.uniq
      keys.inject({}) { |r, key| r[key.to_sym] = permissions.map{ |permission| permission[key] == 'true' }.inject(:|); r }
    end
  end
end

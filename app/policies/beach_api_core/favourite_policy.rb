module BeachApiCore
  class FavouritePolicy < ApplicationPolicy
    def destroy?
      record.user == user
    end
  end
end
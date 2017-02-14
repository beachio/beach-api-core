module BeachApiCore::Concerns::KeeperRoles
  extend ActiveSupport::Concern

  included do
    has_many :assignments, as: :keeper, inverse_of: :keeper, dependent: :destroy, class_name: 'BeachApiCore::Assignment'
    has_many :developers, -> { BeachApiCore::Assignment.developers }, through: :assignments, source: :user,
                                                                      class_name: 'BeachApiCore::User'
    has_many :admins, -> { BeachApiCore::Assignment.admins }, through: :assignments, source: :user,
             class_name: 'BeachApiCore::User'
  end
end

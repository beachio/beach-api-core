module BeachApiCore::Concerns::KeeperRoles
  extend ActiveSupport::Concern

  included do
    has_many :assignments, as: :keeper, inverse_of: :keeper, dependent: :destroy, class_name: 'BeachApiCore::Assignment'
    has_many :developers, -> { BeachApiCore::Assignment.developers }, through: :assignments, source: :user,
                                                                      class_name: 'BeachApiCore::User'
    has_many :admins, -> { BeachApiCore::Assignment.admins }, through: :assignments, source: :user,
             class_name: 'BeachApiCore::User'

    def display_name
      case self.class.to_s
      when 'BeachApiCore::Instance' then 'Current Instance'
      when 'Doorkeeper::Application' then "Application - #{name}"
      else name
      end
    end
  end
end

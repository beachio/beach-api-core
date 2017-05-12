module BeachApiCore::Concerns::ApplicationExtension
  extend ActiveSupport::Concern
  include BeachApiCore::Concerns::KeeperRoles

  included do
    belongs_to :owner, polymorphic: true
    has_many :capabilities, class_name: 'BeachApiCore::Capability'
    has_many :services, through: :capabilities, class_name: 'BeachApiCore::Service'
    has_many :organisations, class_name: 'BeachApiCore::Organisation', dependent: :destroy

    def policy_class
      BeachApiCore::OAuthApplicationPolicy
    end
  end
end

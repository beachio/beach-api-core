module BeachApiCore::Concerns::ApplicationExtension
  extend ActiveSupport::Concern
  include BeachApiCore::Concerns::KeeperRoles

  included do
    belongs_to :owner, polymorphic: true
    has_many :capabilities, class_name: 'BeachApiCore::Capability', dependent: :destroy
    has_many :services, through: :capabilities, class_name: 'BeachApiCore::Service'
    has_many :organisations, class_name: 'BeachApiCore::Organisation', dependent: :destroy
    has_many :jobs, class_name: 'BeachApiCore::Job', dependent: :destroy
    has_many :webhooks, class_name: 'BeachApiCore::Webhook', dependent: :destroy
    has_many :owned_chats, class_name: 'BeachApiCore::Chat', as: :keeper, inverse_of: :keeper, dependent: :destroy
    has_many :bots, class_name: "BeachApiCore::Bot"
    accepts_nested_attributes_for :services, allow_destroy: true
    accepts_nested_attributes_for :capabilities, allow_destroy: true

    def policy_class
      BeachApiCore::OAuthApplicationPolicy
    end
  end
end

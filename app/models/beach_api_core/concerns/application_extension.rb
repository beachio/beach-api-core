module BeachApiCore::Concerns::ApplicationExtension
  extend ActiveSupport::Concern

  included do
    belongs_to :owner, polymorphic: true
    has_many :capabilities, class_name: 'BeachApiCore::Capability'
    has_many :services, through: :capabilities, class_name: 'BeachApiCore::Service'

    def policy_class
      BeachApiCore::OAuthApplicationPolicy
    end
  end
end
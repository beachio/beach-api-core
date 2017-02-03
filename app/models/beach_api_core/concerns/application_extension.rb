module BeachApiCore::Concerns::ApplicationExtension
  extend ActiveSupport::Concern

  included do
    belongs_to :owner, polymorphic: true
    has_many :capabilities
    has_many :services, through: :capabilities

    def policy_class
      OAuthApplicationPolicy
    end
  end
end

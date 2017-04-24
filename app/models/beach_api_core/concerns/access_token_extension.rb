module BeachApiCore::Concerns::AccessTokenExtension
  extend ActiveSupport::Concern

  included do
    belongs_to :organisation, class_name: 'BeachApiCore::Organisation'
    belongs_to :user, class_name: 'BeachApiCore::User', foreign_key: :resource_owner_id
  end
end

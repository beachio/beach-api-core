module BeachApiCore::Concerns::AccessTokenExtension
  extend ActiveSupport::Concern

  included do
    belongs_to :organisation, class_name: 'BeachApiCore::Organisation'
  end
end

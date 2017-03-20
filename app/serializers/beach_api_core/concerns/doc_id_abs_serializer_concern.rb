module BeachApiCore::Concerns::DocIdAbsSerializerConcern
  extend ActiveSupport::Concern

  included do
    def id
      object.id&.abs
    end
  end
end

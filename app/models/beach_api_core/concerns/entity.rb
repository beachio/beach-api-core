module BeachApiCore::Concerns::Entity
  extend ActiveSupport::Concern

  included do
    def entity
      @_entity ||= BeachApiCore::Entity.lookup_by_instance(self)
    end
  end
end

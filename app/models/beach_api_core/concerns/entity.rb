module BeachApiCore::Concerns::Entity
  extend ActiveSupport::Concern

  included do
    after_create :generate_entity
    after_destroy :destroy_entity

    def entity
      @_entity ||= BeachApiCore::Entity.lookup_by_instance(self)
    end

    private

    def generate_entity
      BeachApiCore::Entity.create(user: user, uid: id, kind: self.class)
    end

    def destroy_entity
      BeachApiCore::Entity.where(uid: id, kind: self.class.name).destroy_all
    end
  end
end

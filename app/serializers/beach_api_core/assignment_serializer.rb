module BeachApiCore
  class AssignmentSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :keeper_type, :keeper_name, :role_name

    def keeper_type
      object.keeper_type.gsub(/.+::/, '')
    end

    def role_name
      object.role&.name
    end

    def keeper_name
      object.keeper.is_a?(BeachApiCore::Instance) ? 'Current Instance' : object.keeper&.name
    end
  end
end

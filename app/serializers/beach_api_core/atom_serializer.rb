module BeachApiCore
  class AtomSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :title, :name, :kind, :atom_parent_id
  end
end

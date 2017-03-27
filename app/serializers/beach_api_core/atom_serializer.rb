module BeachApiCore
  class AtomSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :title, :kind, :atom_parent_id
  end
end

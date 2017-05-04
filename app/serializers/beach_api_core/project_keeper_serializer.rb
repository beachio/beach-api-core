module BeachApiCore
  class ProjectKeeperSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id :id, :keeper_id

    attributes :id, :keeper_id, :keeper_type
  end
end

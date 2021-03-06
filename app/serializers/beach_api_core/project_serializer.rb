module BeachApiCore
  class ProjectSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :name

    has_many :project_keepers
  end
end

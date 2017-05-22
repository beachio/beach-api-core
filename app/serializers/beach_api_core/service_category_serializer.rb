module BeachApiCore
  class ServiceCategorySerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :name
    has_many :services
  end
end

module BeachApiCore
  class EntitySerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id(:id, :user_id)

    attributes :id, :user_id, :uid, :kind, :settings
  end
end

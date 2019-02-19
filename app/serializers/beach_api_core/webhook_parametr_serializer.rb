module BeachApiCore
  class WebhookParametrSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id
    attributes :id, :name, :value
  end
end

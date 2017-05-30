module BeachApiCore
  class WebhookSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id(:id, :application_id)

    attributes :id, :uri, :kind, :application_id
  end
end

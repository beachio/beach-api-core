module BeachApiCore
  class WebhookConfigSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id
    belongs_to :application, serializer: BeachApiCore::AppSerializer
    has_many :webhook_parametrs, serializer: BeachApiCore::WebhookParametrSerializer, key: :webhook_parameters
    attributes :id, :config_name, :uri, :request_method, :request_body
  end
end

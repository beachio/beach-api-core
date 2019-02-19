module BeachApiCore
  class GiftbitConfigSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id
    belongs_to :application, serializer: BeachApiCore::AppSerializer
    has_many :giftbit_brands, serializer: BeachApiCore::GiftbitBrandsSerializer
    attributes :id, :config_name, :email_to_notify
  end
end

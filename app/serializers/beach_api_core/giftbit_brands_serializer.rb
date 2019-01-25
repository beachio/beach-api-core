module BeachApiCore
  class GiftbitBrandsSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id
    attributes :id, :gift_name, :amount, :brand_code, :giftbit_email_template, :email_subject, :email_body
  end
end

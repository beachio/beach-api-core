module BeachApiCore
  class SubscriptionPlanSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :stripe_id, :name, :amount, :interval
  end
end

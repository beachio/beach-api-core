module BeachApiCore
  class PlanSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :stripe_id, :name, :amount, :interval, :plan_for
  end
end
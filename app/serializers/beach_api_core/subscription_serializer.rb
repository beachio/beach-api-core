module BeachApiCore
  class SubscriptionSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :subscription_for
    has_one :plan

    def subscription_for
      object.owner_type == 'BeachApiCore::Organisation' ? 'organisation' : 'user'
    end
  end
end
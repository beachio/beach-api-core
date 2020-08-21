module BeachApiCore
  class NotificationSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :kind, :sent, :message

    belongs_to :user, serializer: BeachApiCore::UserSerializer
  end
end
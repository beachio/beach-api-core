module BeachApiCore
  class ChatSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id(:id)

    attributes :id

    has_many :users
    has_one :last_message, current_user: [:current_user]
  end
end

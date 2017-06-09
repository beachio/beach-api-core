module BeachApiCore
  class Chat::MessageSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern
    acts_as_abs_doc_id(:id)
    acts_with_options :current_user

    attributes :id, :message, :read

    belongs_to :sender

    def read
      object.read(current_user) if current_user
    end
  end
end

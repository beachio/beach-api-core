module BeachApiCore
  class Chat::MessageSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id(:id)

    attributes :id, :message, :read

    belongs_to :sender

    def read
      object.read(current_user) if current_user
    end

    private

    def current_user
      instance_options[:current_user]
    end
  end
end

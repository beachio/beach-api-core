module BeachApiCore
  class MessageSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id(:id)

    attributes :id, :message, :read

    belongs_to :sender

    def read
      object.read(user) if user
    end

    private

    def user
      instance_options[:current_user]
    end
  end
end

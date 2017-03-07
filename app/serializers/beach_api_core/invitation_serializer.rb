module BeachApiCore
  class InvitationSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :email

    belongs_to :group
  end
end

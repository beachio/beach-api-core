module BeachApiCore
  class InvitationSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :email, :created_at
    belongs_to :invitee

    belongs_to :group
  end
end

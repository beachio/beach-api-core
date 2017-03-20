module BeachApiCore
  class OrganisationInvitationSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :email, :created_at

    belongs_to :user, serializer: BeachApiCore::UserSerializer
  end
end

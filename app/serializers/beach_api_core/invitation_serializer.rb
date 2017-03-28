module BeachApiCore
  class InvitationSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :email, :created_at

    belongs_to :invitee
    belongs_to :group
    belongs_to :role
  end
end

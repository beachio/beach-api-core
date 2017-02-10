module BeachApiCore
  class InvitationSerializer < ActiveModel::Serializer
    attributes :id, :email

    belongs_to :group
  end
end

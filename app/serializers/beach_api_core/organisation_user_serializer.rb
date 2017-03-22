module BeachApiCore
  class OrganisationUserSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :email, :joined_at, :role

    has_one :profile, serializer: ProfileSimpleSerializer

    def joined_at
      object.organisation_membership.created_at
    end

    def role
      object.roles
        .find_by(beach_api_core_assignments: { keeper_id: object.organisation.id,
                                               keeper_type: object.organisation.class.name })
    end
  end
end

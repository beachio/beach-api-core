module BeachApiCore
  class OrganisationUserSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :email, :joined_at, :role

    has_one :profile, serializer: ProfileSimpleSerializer

    def joined_at
      object.organisation_memberships.find_by(group: organisation)&.created_at
    end

    def role
      object.roles
        .find_by(beach_api_core_assignments: { keeper_id: organisation.id,
                                               keeper_type: organisation.class.name })
    end

    private

    def organisation
      instance_options[:current_organisation]
    end
  end
end

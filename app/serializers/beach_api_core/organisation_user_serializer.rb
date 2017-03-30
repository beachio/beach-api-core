module BeachApiCore
  class OrganisationUserSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :email, :joined_at, :role

    has_one :profile, serializer: ProfileSimpleSerializer

    def joined_at
      object.organisation_memberships.find_by(group: organisation)&.created_at
    end

    def role
      object.roles.where.has { |u| u.assignments.keeper == organisation }.first
    end

    private

    def organisation
      instance_options[:current_organisation]
    end
  end
end
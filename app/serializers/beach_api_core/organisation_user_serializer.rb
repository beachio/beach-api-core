module BeachApiCore
  class OrganisationUserSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :email, :joined_at, :assignments

    has_one :profile, serializer: ProfileSimpleSerializer

    def joined_at
      object.organisation_memberships.find_by(group: organisation)&.created_at
    end

    def assignments
      ActiveModel::Serializer::CollectionSerializer.new(object.assignments.where(keeper: organisation),
                                                        serializer: BeachApiCore::SimpleAssignmentSerializer)
    end

    private

    def organisation
      instance_options[:current_organisation]
    end
  end
end

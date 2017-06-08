module BeachApiCore
  class OrganisationUserSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id
    acts_with_options :current_organisation

    attributes :id, :email, :joined_at, :assignments

    has_one :profile, serializer: ProfileSimpleSerializer

    def joined_at
      object.organisation_memberships.find_by(group: current_organisation)&.created_at
    end

    def assignments
      ActiveModel::Serializer::CollectionSerializer.new(object.assignments.where(keeper: current_organisation),
                                                        serializer: BeachApiCore::SimpleAssignmentSerializer)
    end
  end
end

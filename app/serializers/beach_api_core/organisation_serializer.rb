module BeachApiCore
  class OrganisationSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id
    acts_with_options(:current_user)

    attributes :id, :name, :logo_url, :logo_properties, :current_user_roles, :subscription

    def logo_url
      object.logo_image&.file_url
    end

    def current_user_roles
      return [] unless current_user
      # Role.joins(:assignments).where.has do |r|
      #   (r.assignments.user_id == current_user.id) & (r.assignments.keeper == object)
      # end.pluck(:name)
      Role.joins(:assignments).where(assignments: {
        user_id: current_user.id,
        keeper: object
      }).pluck(:name)
    end

    def subscription
      object&.subscription
    end
  end
end

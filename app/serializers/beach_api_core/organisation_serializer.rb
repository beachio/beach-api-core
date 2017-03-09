module BeachApiCore
  class OrganisationSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :name, :logo_url, :logo_properties, :current_user_roles

    def logo_url
      object.logo_image&.file_url
    end

    def current_user_roles
      return [] unless user
      Role.joins(:assignments).where.has { |r| (r.assignments.user_id == user.id) &
          (r.assignments.keeper == object) }.pluck(:name)
    end

    private

    def user
      instance_options[:current_user]
    end
  end
end

module BeachApiCore
  class OrganisationSerializer < ActiveModel::Serializer
    attributes :id, :name, :logo_url, :logo_properties, :current_user_roles

    def logo_url
      object.logo_image&.file_url
    end

    def current_user_roles
      return [] unless user
      current_user = user
      current_organisation = object
      Role.joins(:assignments).where.has { (assignments.user_id == current_user.id) &
          (assignments.keeper == current_organisation) }.pluck(:name)
    end

    private

    def user
      instance_options[:current_user]
    end
  end
end

module BeachApiCore
  class OrganisationSerializer < ActiveModel::Serializer
    attributes :id, :name, :logo_url, :logo_properties, :current_user_roles

    def logo_url
      object.logo_image&.file_url
    end

    def current_user_roles
      Role.where.has { |r|
        (r.id.in user.assignments
                     .where.has{ keeper == object}
                     .select(:role_id)) }
          .selecting { name }
    end

    private

    def user
      instance_options[:current_user]
    end
  end
end

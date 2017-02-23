module BeachApiCore
  class OrganisationSerializer < ActiveModel::Serializer
    attributes :id, :name, :logo_url, :logo_properties

    def logo_url
      object.logo_image&.file_url
    end
  end
end

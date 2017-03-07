module BeachApiCore
  class ServiceSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :title, :name, :description, :icon_url

    def icon_url
      object.icon&.file_url
    end
  end
end
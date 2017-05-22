module BeachApiCore
  class ServiceSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :title, :name, :description, :icon_url

    def icon_url
      object.icon&.file_url
    end
  end
end

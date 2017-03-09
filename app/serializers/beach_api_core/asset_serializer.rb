module BeachApiCore
  class AssetSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :file_filename, :file_url, :file_size, :file_content_type, :file_extension
  end
end

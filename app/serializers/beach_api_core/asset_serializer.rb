module BeachApiCore
  class AssetSerializer < ActiveModel::Serializer
    attributes :id, :file_filename, :file_url, :file_size, :file_content_type, :file_extension
  end
end

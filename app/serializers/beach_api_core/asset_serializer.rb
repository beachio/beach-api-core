module BeachApiCore
  class AssetSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :file_filename, :file_url, :file_size, :file_content_type, :file_extension
  end
end

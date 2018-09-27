module BeachApiCore
  class AppSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :name, :mail_type_band_color, :mail_type_band_text_color, :logo_url
  end
end

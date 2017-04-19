module BeachApiCore
  class ProfileSimpleSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :first_name, :last_name
  end
end

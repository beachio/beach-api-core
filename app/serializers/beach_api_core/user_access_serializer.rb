module BeachApiCore
  class UserAccessSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :keeper_id, :keeper_type, :access_level_id
    belongs_to :user, serializer: BeachApiCore::UserSimpleSerializer
  end
end

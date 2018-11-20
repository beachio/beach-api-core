module BeachApiCore
  class DeviceSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id(:id)

    attributes :id, :name, :user_id, :created_at, :data
  end
end

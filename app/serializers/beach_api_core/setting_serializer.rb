module BeachApiCore
  class SettingSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id(:id, :keeper_id)

    attributes :id, :name, :value, :keeper_type, :keeper_id
  end
end

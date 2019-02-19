module BeachApiCore
  class DeviceSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern
    acts_as_abs_doc_id(:id)
    acts_with_options(:current_application)
    attributes :id, :name, :scores, :user_id, :created_at, :data

    def scores
      return 0 if current_application.nil?
      scores = object.scores.find_by(:application => current_application)
      return scores.nil? ? 0 : scores.scores
    end


    def filter(keys)
      keys - [:id, :scores, :user_id, :data] if to_channel
      keys
    end
  end
end

module BeachApiCore
  class BotSerializer < ActiveModel::Serializer
    attributes :id, :name, :avatar

    def avatar
      object.avatar&.file_url
    end
  end
end

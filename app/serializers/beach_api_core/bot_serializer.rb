module BeachApiCore
  class BotSerializer < ActiveModel::Serializer
    attributes :id, :name, :avatar

    def avatar
      Refile.attachment_url(object.avatar, :file, :fill, 150, 150)
    end
  end
end

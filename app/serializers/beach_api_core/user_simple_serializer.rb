module BeachApiCore
  class UserSimpleSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id
    acts_with_options(:host_url)

    attributes :id, :email, :username, :first_name, :last_name, :avatar_url

    def avatar_url
      host_url + object.profile.avatar.file_url rescue nil
    end
  end
end

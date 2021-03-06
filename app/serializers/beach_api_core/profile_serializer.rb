module BeachApiCore
  class ProfileSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id
    acts_with_options(:keepers, :host_url)

    attributes :id, :first_name, :last_name, :birth_date, :sex, :time_zone, :avatar_url, :notifications_enabled

    def attributes(*)
      result = super
      ProfileCustomField.where(keeper: keepers).each do |profile_custom_field|
        profile_attribute = object.profile_attributes.find_by(profile_custom_field: profile_custom_field)
        result[profile_custom_field.name] = profile_attribute&.value
      end
      result
    end

    def avatar_url
      host_url + object.avatar.file_url rescue nil
    end
  end
end

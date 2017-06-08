module BeachApiCore
  class UserSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id
    acts_with_options :current_user, :current_application

    attributes :id, :email, :username, :user_preferences, :is_me
    has_one :profile, serializer: BeachApiCore::ProfileSerializer
    has_many :organisations

    def user_preferences
      return [] unless current_application
      object.user_preferences.where(application: current_application)
    end

    def is_me
      object == current_user
    end
  end
end

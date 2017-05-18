module BeachApiCore
  class UserSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :email, :username, :user_preferences, :is_me
    has_one :profile, serializer: BeachApiCore::ProfileSerializer
    has_many :organisations

    def user_preferences
      return [] unless application
      object.user_preferences.where(application: application)
    end

    def is_me
      object == instance_options[:current_user]
    end

    private

    def application
      instance_options[:current_application]
    end
  end
end

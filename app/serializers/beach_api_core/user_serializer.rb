module BeachApiCore
  class UserSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id
    acts_with_options(:current_user, :current_application)

    attributes :id, :email, :username, :user_preferences, :is_me, :roles, :scores
    has_one :profile, serializer: BeachApiCore::ProfileSerializer
    has_many :organisations
    has_many :teams

    def user_preferences
      return [] unless current_application
      object.user_preferences.where(application: current_application)
    end

    def is_me
      object == current_user
    end

    def roles
      Hash[object.roles.map{|r| [r.name, true]}]
    end

    def scores
      return 0 unless current_application
      scores = BeachApiCore::Score.find_by(:application_id => current_application.id, :user_id => object.id)
      scores.nil? ? 0 : scores.scores
    end
  end
end

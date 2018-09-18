module BeachApiCore
  class TeamSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id
    acts_with_options(:current_user)

    attributes :id, :name, :current_user_roles

    def current_user_roles
      return [] unless current_user
      Role.joins(:assignments).where.has do |r|
        (r.assignments.user_id == current_user.id) & (r.assignments.keeper == object)
      end.pluck(:name)
    end
  end
end

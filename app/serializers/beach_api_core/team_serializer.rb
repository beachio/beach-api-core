module BeachApiCore
  class TeamSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id
    acts_with_options(:current_user)

    attributes :id, :name, :is_owner, :current_user_roles

    def current_user_roles
      return [] unless current_user
      Role.joins(:assignments).where.has do |r|
        (r.assignments.user_id == current_user.id) & (r.assignments.keeper == object)
      end.pluck(:name)
    end

    def is_owner
      return false unless current_user
      object.owners.pluck(:id).include? current_user.id
    end
  end
end

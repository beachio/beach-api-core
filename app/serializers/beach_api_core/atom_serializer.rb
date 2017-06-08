module BeachApiCore
  class AtomSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id :id, :atom_parent_id
    acts_with_options :current_user, :current_organisation

    attributes :id, :title, :name, :kind, :atom_parent_id, :actions

    def actions
      puts current_user.inspect
      return [] unless current_user
      current_user.permissions_for(object, current_organisation)
    end
  end
end

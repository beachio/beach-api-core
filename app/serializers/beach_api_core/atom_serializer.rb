module BeachApiCore
  class AtomSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id :id, :atom_parent_id

    attributes :id, :title, :name, :kind, :atom_parent_id, :actions

    def actions
      return [] unless user
      user.permissions_for(object, organisation)
    end

    private

    def user
      instance_options[:current_user]
    end

    def organisation
      instance_options[:current_organisation]
    end
  end
end

ActiveAdmin.register BeachApiCore::Atom, as: 'Atom' do
  menu priority: 30, parent: 'Permissions'

  permit_params :title, :kind, :atom_parent_id

  index do
    id_column
    column :title
    column :kind
    column :atom_parent
    actions
  end

  filter :kind
  filter :title

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.atom.one')) do
      f.input :title
      f.input :kind, as: :select, collection: %w(item simple_item)
      f.input :atom_parent, collection: BeachApiCore::Atom.where.not(id: f.object.id)
    end
    f.actions
  end

  show do |_atom|
    attributes_table do
      row :id
      row :title
      row :kind
      row :atom_parent
    end
  end
end

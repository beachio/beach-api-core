ActiveAdmin.register BeachApiCore::Permission, as: 'Permission' do
  menu priority: 40, parent: 'Permissions'

  permit_params { params[resource_class.name.demodulize.underscore.to_sym]&.keys unless request.get? }

  collection_action :autocomplete_keeper, method: :get do
    term = "%#{params[:term]}%"
    list = BeachApiCore::User.where('email ILIKE :term OR username ILIKE :term', term: term).limit(5) +
           BeachApiCore::Role.where('name ILIKE :term', term: term).limit(5) +
           BeachApiCore::Team.where('name ILIKE :term', term: term).limit(5) +
           BeachApiCore::Organisation.where('name ILIKE :term', term: term).limit(5)

    render json: list.map { |item| "#{item.try(:email) || item.try(:name)} (#{item.class}, #{item.id})" }
  end

  controller do
    before_action :normalize_params, only: %i(create update)
    before_action :clear_actions, only: [:update]

    private

    def clear_actions
      resource.actions = {}
    end

    def normalize_params
      if params[:permission][:keeper] =~ /\((.*), (\d+)\)/
        params[:permission][:keeper_type] = Regexp.last_match(1)
        params[:permission][:keeper_id] = Regexp.last_match(2)
      else
        params[:permission][:keeper_id] = params[:permission][:keeper_type] = nil
      end
      params[:permission].delete(:keeper)
    end
  end

  index do
    id_column
    column :atom
    column :keeper_id
    column :keeper_type
    column :actor
    actions
  end

  filter :atom
  filter :keeper_id
  filter :keeper_type

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.permission.one')) do
      f.input :atom
      f.input :keeper, as: :autocomplete, url: autocomplete_keeper_admin_permissions_path,
                       input_html: { value: f.object.keeper_name }
      actions = if f.object.actions.keys.blank?
                  %w(create read update delete execute)
                else
                  f.object.actions.keys
                end
      actions.sort_by(&:to_s).map do |action|
        f.input "action_#{action}", as: :boolean,
                                    checked_value: 'true',
                                    unchecked_value: 'false',
                                    label: action,
                                    wrapper_html: { class: 'js-action-wrapper' }
      end
      span(id: 'js-action-placeholder')
      li(class: 'input ba-add-action') do
        span text_field_tag(:new_action)
        span button_tag('Add', id: 'js-add-action', type: 'button')
      end
      f.input :actor
    end
    f.actions
  end

  show do |permission|
    attributes_table do
      row :id
      row :atom
      row :keeper_id
      row :keeper_type
      row :actor
      row :actions do
        table do
          permission.actions.sort.each do |key, value|
            tr do
              td key
              td value.to_s
            end
          end
        end
      end
    end
  end
end

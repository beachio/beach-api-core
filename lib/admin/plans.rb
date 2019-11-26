ActiveAdmin.register BeachApiCore::Plan, as: 'Plan' do
  menu parent: 'Organisations'

  permit_params :name, :amount, :stripe_id, :interval, :plan_for, :amount_per_additional_user, :users_count,
                plan_items_attributes: %i(id access_level_id users_count)

  index do
    id_column
    column :name
    column :stripe_id
    actions
  end

  filter :name

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.plan.one')) do
      f.input :name
      f.input :amount
      f.input :stripe_id
      if f.object.new_record?
        f.input :interval, as: :select, collection: [["Day", "day"], ["Month", "month"], ["Year", "year"]]
        f.input :plan_for
      else
        f.input :interval, as: :select, collection: [["Day", "day"], ["Month", "month"], ["Year", "year"]], input_html: {disabled: true}
        f.input :plan_for, input_html: {disabled: true}
      end
      f.has_many :plan_items, allow_destroy: true,
                 heading: t('activerecord.models.plan_option.other') do |o|
        o.input :access_level, as: :select, collection: BeachApiCore::AccessLevel.all,
                label: t('activerecord.models.access_level.one')
        o.input :users_count
      end
    end
    f.actions
  end

  show do |_plan|
    attributes_table do
      row :name
      row :stripe_id
      row :amount
      row :interval
      row :plan_for
      if _plan.plan_items.any?
        panel 'Plan_Options' do
          table_for _plan.plan_items do
            column :access_level
            column :users_count
          end
        end
      end
    end
  end
end

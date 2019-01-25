custom_device = BeachApiCore::Setting.custom_device(keeper: BeachApiCore::Instance.current)
if custom_device.nil? || custom_device == 'default'
  ActiveAdmin.register BeachApiCore::Device, as: 'Device' do
    permit_params :name, :application_id

    index do
      id_column
      column :name
      column :application
      actions
    end

    filter :name
    filter :application

    form do |f|
      f.inputs t('active_admin.details', model: t('activerecord.models.beach_api_core/device.one')) do
        f.input :name
        f.input :application
        #   f.input :data
      end
      f.actions
    end

    show do
      attributes_table do
        row :name
        row :user
        row :application
        row :data
      end
    end
  end
end

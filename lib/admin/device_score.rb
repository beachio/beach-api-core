ActiveAdmin.register BeachApiCore::DeviceScore, as: 'DevicesScores' do
  menu parent: 'Devices'
  permit_params :application_id, :device_id, :scores
  filter :application
  filter :device
  filter :scores
  show do
    attributes_table do
      row :device
      row :application
      row :scores
    end
  end

  index do
    id_column
    column :device do |device_score|
      link_to(device_score.device.name, admin_device_path(device_score.device.id))
    end
    column :application
    column :scores
    actions
  end

  form do |f|
    f.inputs "Achievement Details" do
      f.semantic_errors *f.object.errors.keys
      f.input :device
      f.input :application
      f.input :scores
    end
    f.actions
  end
end

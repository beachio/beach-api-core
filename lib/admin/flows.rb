ActiveAdmin.register BeachApiCore::Flow, as: 'Flows' do
  menu priority: 102

  index do
    id_column
    column :name
    column do |flow|
      open_in_mobile(flow.screens.first)
    end
    actions
  end

  show do |flow|
    attributes_table do
      row :name
    end

    open_in_mobile(flow.screens.first)
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.screens :screens
    f.actions
  end

  controller do
    def resource_params
      return [] if request.get?
      res = params.require(:flow).permit(:name)
      res[:screens_attributes] = JSON.parse(params[:flow][:screens]) rescue []
      return res
    end
  end
end
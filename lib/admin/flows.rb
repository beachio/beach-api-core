ActiveAdmin.register BeachApiCore::Flow, as: 'Flows' do
  menu priority: 102

  index do
    id_column
    column :name
    actions
  end

  index as: :directories_grid, default: true do
    directories_grid
  end

  show do |flow|
    attributes_table do
      row :name
    end

    open_in_mobile(flow.screens.first)
  end

  form do |f|
    dirs = (BeachApiCore::Directory.where("ancestry is null").order(:ancestry) + BeachApiCore::Directory.where("ancestry is not null").order(:ancestry)).map{|t| ["-"*(t.ancestry || "").split("/").count + t.name, t.id]}
    f.inputs do
      f.input :directory_id, :label => 'Directory', :as => :select, :collection => dirs
      f.input :name
    end
    f.screens :screens
    f.actions
  end

  collection_action :directories, method: [:get, :post, :put, :delete] do
    if request.get?
      @directories = ActiveModel::Serializer::CollectionSerializer.new(BeachApiCore::Directory.roots, each_serializer: BeachApiCore::DirectorySerializer).as_json
      render json: @directories
    elsif request.post?
      directory_params = params.require(:directory).permit(:name, :parent_id)
      render json: BeachApiCore::Directory.create(directory_params)
    elsif request.put?
      directory_params = params.require(:directory).permit(:name, :parent_id)
      render json: BeachApiCore::Directory.find(params[:id]).update(directory_params)
    elsif request.delete?
      BeachApiCore::Directory.find(params[:id]).destroy
      render json: {}
    end
  end

  collection_action :flows, method: [:post, :put, :delete] do
    if request.post?
      flow_params = params.require(:flow).permit(:name, :directory_id)
      render json: BeachApiCore::Flow.create(flow_params)
    elsif request.put?
      flow_params = params.require(:flow).permit(:name, :parent_id)
      render json: BeachApiCore::Flow.find(params[:id]).update(flow_params)
    elsif request.delete?
      BeachApiCore::Flow.find(params[:id]).destroy
      render json: {}
    end

  end

  controller do
    skip_before_action :verify_authenticity_token

    def resource_params
      return [] if request.get?
      res = params.require(:flow).permit(:name)
      res[:screens_attributes] = JSON.parse(params[:flow][:screens]) rescue []
      res[:directory_id] = params[:flow][:directory_id]
      return res
    end
  end
end
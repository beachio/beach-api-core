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
    f.inputs do
      unless f.object.main?
        f.input :directory_id, :label => 'Directory', :as => :select, :collection => BeachApiCore::Directory.dirs
      end
      f.input :name
      f.input :locked
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

  collection_action :flows, method: [:post, :put, :delete, :get] do
    if request.get? && params[:main]
      @flow = BeachApiCore::Flow.main
      render json: @flow
    elsif request.post?
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

  member_action :screens, method: [:get] do
    if request.get? && params[:id]
      @flow = BeachApiCore::Flow.find(params[:id])
      render json: @flow.screens, adapter: :attributes
    end
  end

  collection_action :images, method: [:post, :delete] do
    if request.post?
      entity = BeachApiCore::Entity.create(user: current_user, uid: SecureRandom.uuid, kind: "FlowImage")
      asset = BeachApiCore::Asset.create(file: params.permit![:attachments].first, entity: entity)
      
      render json: {url: asset.file_url, id: asset.id}
    elsif request.delete?
      BeachApiCore::Asset.find(params[:id]).destroy
      render json: {}
    end
  end

  controller do
    skip_before_action :verify_authenticity_token

    def resource_params
      return [] if request.get?
      res = params.require(:flow).permit(:name, :locked)

      screens_attributes = JSON.parse(params[:flow][:screens])
      screens_attributes.each{|t| t.delete("$$hashKey")} rescue []

      res[:screens_attributes] = screens_attributes
      res[:directory_id] = params[:flow][:directory_id]
      return res
    end
  end
end
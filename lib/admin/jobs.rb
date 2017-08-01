ActiveAdmin.register BeachApiCore::Job, as: 'Job' do
  menu priority: 80

  permit_params :start_at, :every, :application_id, params: [:method, :uri, :input, headers: {}]

  index do
    id_column
    column :start_at
    column :done
    column :every
    column :last_run
    actions
  end

  filter :done
  filter :start_at
  filter :last_run

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.job.one')) do
      f.input :start_at, as: :date_time_picker
      f.input :every
      f.input :params, input_html: { value: f.object.params.to_json }
      f.input :application, as: :select, collection: Doorkeeper::Application.all
    end
    f.actions
  end

  show do |job|
    attributes_table do
      row :id
      row :application
      row :start_at
      row :done
      row :every
      row :last_run
      row :params do
        span job.params.to_json
      end
      row :result
    end
  end

  controller do
    before_action :serialize_params, only: %i(create update)

    private

    def serialize_params
      parse_job_params
      params[:job][:every] = nil if params[:job][:every].blank?
      return if params[:job][:params][:uri].blank? || params[:job][:params][:uri].match?(%r{\Ahttps?://})
      params[:job][:params][:uri] = URI.join(request.base_url, params[:job][:params][:uri]).to_s
    end

    def parse_job_params
      return if params[:job][:params].blank?
      params[:job][:params] = begin
                                JSON.parse(params[:job][:params])
                              rescue
                                {}
                              end
    end
  end
end

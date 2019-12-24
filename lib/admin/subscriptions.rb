ActiveAdmin.register BeachApiCore::Subscription, as: 'Subscription' do
  menu priority: 66, parent: 'Services'

  permit_params :plan_id, :owner_type, :owner_id, :user_id, :organisation_id

  form do |f|

    f.inputs do
      #f.semantic_errors *f.object.errors.keys

      f.input :plan
      if f.object.new_record?
        f.input :owner_type,
                as: :select,
                collection: [
                  ['User', 'BeachApiCore::User'],
                  ['Organisation', 'BeachApiCore::Organisation']
                ]
        f.input :user_id, input_html: { id: "owner_user_input" }, as: :select, collection: BeachApiCore::User.all
        f.input :organisation_id, input_html: { id: "owner_organisation_input" }, as: :select, collection: BeachApiCore::Organisation.all
      end
      f.actions
    end
  end

  controller do
    def create
      case params[:subscription][:owner_type]
      when 'BeachApiCore::User'
        params[:subscription][:owner_id] = params[:subscription][:user_id]
      when 'BeachApiCore::Organisation'
        params[:subscription][:owner_id] = params[:subscription][:organisation_id]
      end
      super
    end
  end
end

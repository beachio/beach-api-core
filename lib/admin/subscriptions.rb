ActiveAdmin.register BeachApiCore::Subscription, as: 'Subscription' do
  menu priority: 66, parent: 'Services'

  permit_params :plan_id, :owner_type, :owner_id, :user_id, :organisation_id, :cvc, :exp_year, :exp_month, :number, :application_id

  form do |f|

    f.inputs do
      f.semantic_errors *f.object.errors.keys
      if f.object.new_record?
        f.input :owner_type,
                as: :select,
                collection: [
                    ['User', 'BeachApiCore::User'],
                    ['Organisation', 'BeachApiCore::Organisation']
                ]
        f.input :user_id, input_html: { id: "owner_user_input" }, as: :select, collection: BeachApiCore::User.all
        f.input :organisation_id, input_html: { id: "owner_organisation_input" }, as: :select, collection: BeachApiCore::Organisation.all
        f.input :application, as: :select, collection: Doorkeeper::Application.all.map {|app| ["#{app.name} - Stripe Mode: #{app.test_stripe ? 'Test' : 'Live'}", app.id]}
        f.input :number, as: :number
        f.input :exp_month, as: :number
        f.input :exp_year, as: :number
        f.input :cvc, as: :number
      end
      f.input :plan, as: :select, collection: BeachApiCore::Plan.all.map {|plan| ["#{plan.name} - #{plan.plan_for.capitalize} - Stripe Mode: #{plan.test ? 'Test' : 'Live'}", plan.id]}
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

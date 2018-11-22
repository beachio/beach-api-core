ActiveAdmin.register BeachApiCore::Score, as: 'Scores' do
  menu priority: 60, parent: 'Users'
  permit_params :application_id, :user_id, :scores

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.mail_body.one')) do
      if f.object.new_record?
        f.input :application
        f.input :user
      else
        f.input :application, :input_html => { :disabled => true }
        f.input :user, :input_html => { :disabled => true }
      end

      f.input :scores
    end
    f.actions
  end
end
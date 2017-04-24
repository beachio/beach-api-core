module BeachApiCore
  class V1::EmailsController < BeachApiCore::V1::BaseController
    include EmailsDoc

    resource_description do
      name 'Emails'
    end

    def create
      EmailCreate.call(params: email_params,
                       scheduled_time: params[:email][:scheduled_time])
      head :created
    end

    private

    def email_params
      { from: params[:email][:from],
        to: recipients,
        cc: params[:email][:cc],
        subject: params[:email][:subject],
        body: params[:email][:body],
        layout: params[:email][:template] }
    end

    def recipients
      if params[:email][:user_ids]
        User.where(id: params[:email][:user_ids]).pluck(:email).join(',')
      else
        params[:email][:to]
      end
    end
  end
end

module BeachApiCore
  class V1::EmailsController < BeachApiCore::V1::BaseController
    include EmailsDoc

    resource_description do
      name 'Emails'
    end

    def create
      result = EmailInteractor::Send.call(
        params: email_params,
        scheduled_time: params[:email][:scheduled_time],
        headers: request.headers['HTTP_AUTHORIZATION']
      )
      if result.success?
        # @todo: more meaningful message?
        render_json_success({ message: 'Email has been created' }, :created)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def email_params
      { from: params[:email][:from],
        to: recipients,
        cc: params[:email][:cc],
        subject: params[:email][:subject],
        body: params[:email][:body] }
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

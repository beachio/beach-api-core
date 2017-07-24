module BeachApiCore
  class V1::EmailsController < BeachApiCore::V1::BaseController
    include EmailsDoc
    before_action :explicit_application_with_user_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/email.other')
    end

    def create
      result = EmailCreate.call(params.permit!.to_h)
      if result.success?
        # @todo: more meaningful message?
        render_json_success({ message: I18n.t('api.errors.email_has_been_created') }, result.status)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end
  end
end

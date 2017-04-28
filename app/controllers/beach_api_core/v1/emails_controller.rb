module BeachApiCore
  class V1::EmailsController < BeachApiCore::V1::BaseController
    include EmailsDoc
    before_action :explicit_application_authorize!

    resource_description do
      name 'Emails'
    end

    def create
      result = EmailCreate.call(params)
      if result.success?
        # @todo: more meaningful message?
        render_json_success({ message: 'Email has been created' }, result.status)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end
  end
end

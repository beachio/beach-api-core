module BeachApiCore
  class V1::MailBodiesController < V1::BaseController
    include BeachApiCore::Concerns::V1::GroupResourceConcern
    include MailBodiesDoc
    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/mail_body.other')
    end

    def index
      owner? ? render_json_success(current_application.mail_bodies, :ok,
          each_serializer: BeachApiCore::MailBodySerializer, root: :mail_bodies) : render_json_error({message: "You are not authorized to make this request"})
    end

    def show
      if owner?
        mail_body = current_application.mail_bodies.where(:id => params[:id]).first
        if mail_body.nil?
          render_json_error({message: "There are no such mail body for this application"})
        else
          render_json_success(mail_body, :ok, serializer: BeachApiCore::MailBodySerializer, root: :mail_body)
        end
      else
        render_json_error({message: "You are not authorized to make this request"})
      end
    end

    def create
      if owner?
        result = BeachApiCore::MailBodyCreate.call(
            application: current_application, params: mail_body_params
        )

        if result.success?
          render_json_success(result.mail_body, result.status,
                              serializer: BeachApiCore::MailBodySerializer, root: :mail_body)
        else
          render_json_error({ message: result.message }, result.status)
        end
      else
        render_json_error({message: "You are not authorized to make this request"})
      end
    end

    def update
      if owner?
        mail_body = BeachApiCore::MailBody.where(:id => params[:id], application_id: current_application.id).first
        if mail_body.nil?
          render_json_error({message: "There are no such mail body for this application"})
        else
          result = BeachApiCore::MailBodyUpdate.call(
              mail_body: mail_body, params: mail_body_params
          )

          if result.success?
            render_json_success(result.mail_body, result.status,
                                serializer: BeachApiCore::MailBodySerializer, root: :mail_body)
          else
            render_json_error({ message: result.message }, result.status)
          end
        end

      else
        render_json_error({message: "You are not authorized to make this request"})
      end
    end

    def destroy
      if owner?
        mail_body = current_application.mail_bodies.where(:id => params[:id]).first
        if mail_body.nil?
          render_json_error({ message: I18n.t('api.errors.could_not_remove',
                                              model: I18n.t('activerecord.models.beach_api_core/mail_body.downcase')) },
                            :bad_request)
        else
          if mail_body.destroy
            head :no_content
          else
            render_json_error({ message: I18n.t('api.errors.could_not_remove',
                                                model: I18n.t('activerecord.models.beach_api_core/mail_body.downcase')) },
                              :bad_request)
          end
        end
      else
        render_json_error({message: "You are not authorized to make this request"})
      end

    end

    def owner?
      current_application.owner_id == current_user.id
    end

    private

    def mail_body_params
      params.require(:mail_body).permit(:mail_type, :text_color, :button_color, :button_text, :body_text,
                                          :button_text_color, :greetings_text, :signature_text, :footer_text)
    end
  end
end

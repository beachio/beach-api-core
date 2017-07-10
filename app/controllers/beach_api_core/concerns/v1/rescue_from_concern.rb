module BeachApiCore::Concerns::V1::RescueFromConcern
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render_json_error({ message: exception.message }, :not_found)
    end

    rescue_from Pundit::NotAuthorizedError do |_|
      render_json_error({ message: 'You are not authorized to make this request' }, :forbidden)
    end

    rescue_from BeachApiCore::Exception::NotAcceptable do |_|
      render_json_error({ message: 'Not acceptable' }, :not_acceptable)
    end

    rescue_from ActiveSupport::MessageVerifier::InvalidSignature do |_|
      render_json_error({ message: 'Invalid token' }, :bad_request)
    end

    rescue_from Apipie::ParamMissing do |e|
      render_json_error({ message: e.message }, :unprocessable_entity)
    end

    rescue_from Apipie::ParamInvalid do |e|
      render_json_error({ message: e.message }, :unprocessable_entity)
    end

    rescue_from BeachApiCore::Exception::ParamMissing do |e|
      render_json_error({ message: e.message }, :unprocessable_entity)
    end
  end
end

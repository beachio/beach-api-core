module BeachApiCore::Concerns::V1::RescueFromConcern
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render_json_error({ message: exception.message }, :not_found)
    end

    rescue_from Pundit::NotAuthorizedError do |exception|
      render_json_error({ message: 'You are not authorized make this request' }, :forbidden)
    end
  end
end

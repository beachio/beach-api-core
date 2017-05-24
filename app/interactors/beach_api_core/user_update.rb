class BeachApiCore::UserUpdate
  include Interactor

  before do
    if context.params.include?('password')
      context.user.assign_attributes(require_confirmation: true, require_current_password: true)
    end
    context.user.profile.keepers = context.keepers
  end

  def call
    current_application = context.keepers.detect{ |k| k.is_a?(Doorkeeper::Application) }
    if context.params[:user_preferences_attributes]
      context.params[:user_preferences_attributes].each do |attr|
        attr.merge!(application: current_application)
      end
    end
    if context.user.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.user.errors.full_messages
    end
  end
end

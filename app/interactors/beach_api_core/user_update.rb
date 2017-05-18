class BeachApiCore::UserUpdate
  include Interactor

  def call
    context.user.profile.keepers = context.keepers
    context.user.require_confirmation = true if context.params.include?('password')
    current_application = context.keepers.detect{ |k| k.is_a?(Doorkeeper::Application) }
    context.params[:user_preferences_attributes].each do |attr|
      attr.merge!(application: current_application)
    end if context.params[:user_preferences_attributes]
    if context.user.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.user.errors.full_messages
    end
  end
end

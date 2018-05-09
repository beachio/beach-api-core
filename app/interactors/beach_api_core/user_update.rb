class BeachApiCore::UserUpdate
  include Interactor

  before do
    if context.params.include?('password')
      context.user.assign_attributes(require_confirmation: true, require_current_password: true)
    end

    if context.params.include?("profile_attributes")
      #rails delete profile if id is not required
      if context.params["profile_attributes"]["id"] != context.user.profile.id
        context.params["profile_attributes"]["id"] = context.user.profile.id
      end

      if context.params["profile_attributes"].include?("current_age")
        age = context.params["profile_attributes"]["current_age"].to_i

        if age > 0
          birth_date = Date.today - age.year
          context.params["profile_attributes"]["birth_date"] = (birth_date - 1.day)
          context.params["profile_attributes"].delete("current_age")
        end
      end
    end

    context.user.profile.keepers = context.keepers
  end

  def call
    current_application = context.keepers.detect { |k| k.is_a?(Doorkeeper::Application) }
    context.params[:user_preferences_attributes]&.each do |attr|
      attr.merge!(application: current_application)
    end
    if context.user.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.user.errors.full_messages
    end
  end

end

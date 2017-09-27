module BeachApiCore::UserInteractor
  class Create
    include Interactor

    before do
      context.user = context.model = new_user # create with alias
      context.event = 'created'
    end

    def call
      if context.user.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: new_user.errors.full_messages
      end
    end

    private

    def new_user
      # need to slice only user-specific fields out of the context
      # other fields pertain to the user's profile instead
      @_user ||= BeachApiCore::User.new context.to_h.slice(:email, :username, :password)
    end
  end
end

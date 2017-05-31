module BeachApiCore::UserInteractor
  class CreateAccessToken
    include Interactor

    # TODO: do we need this Interactor?
    def call
      return unless context.application_id
      context.access_token = Doorkeeper::AccessToken.create!(application_id: context.application_id,
                                                             resource_owner_id: context.user_id)
    end
  end
end

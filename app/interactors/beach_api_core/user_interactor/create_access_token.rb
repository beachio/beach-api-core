module BeachApiCore::UserInteractor
  class CreateAccessToken
    include Interactor

    def call
      Doorkeeper::AccessToken.create!(application_id: context.application_id,
                                      resource_owner_id: context.user_id ) if context.application_id
    end
  end
end

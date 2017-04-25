module BeachApiCore
  class ValidateApplication
    include Interactor

    def call
      return if context.application
      context.fail!(
        message: ['Application ID and/or secret are not correct'],
        status: :unauthorized
      )
    end
  end
end

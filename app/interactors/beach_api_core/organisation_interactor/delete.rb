module BeachApiCore::OrganisationInteractor
  class Delete
    include Interactor

    before do
      context.model = context.organisation
      context.event = 'deleted'
    end

    def call
      return if context.organisation.destroy
      context.fail! message: I18n.t('api.errors.could_not_remove',
                                    model: I18n.t('activerecord.models.organisation.downcase'))
    end
  end
end

class BeachApiCore::InteractionDestroy
  include Interactor

  def call
    if context.interaction.destroy
      context.status = :destroyed
    else
      context.status = :bad_request
      context.fail! message: I18n.t('api.errors.could_not_remove_this',
                                    model: I18n.t('activerecord.models.interaction.downcase'))
    end
  end
end

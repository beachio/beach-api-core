class BeachApiCore::SettingUpdate
  include Interactor

  def call
    context.setting = setting
    if context.setting.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.setting.errors.full_messages
    end
  end

  private

  def setting
    BeachApiCore::Setting.find_or_create_by(name: context.name,
                                            keeper: context.keeper)
  end
end

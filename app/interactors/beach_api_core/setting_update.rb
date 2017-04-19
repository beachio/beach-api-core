class BeachApiCore::SettingUpdate
  include Interactor

  before do
    context.setting = BeachApiCore::Setting.find_or_create_by(name: context.name,
                                                              keeper: context.keeper)
  end

  def call
    if context.setting.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.setting.errors.full_messages
    end
  end
end

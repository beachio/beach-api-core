class BeachApiCore::PermissionSet
  include Interactor
  include BeachApiCore::Concerns::PolymorphicParamsConcern

  before do
    params = normalize_polymorphic_class(context.params)
    context.keeper = params[:keeper_type].constantize.find(params[:keeper_id])
  end

  def call
    context.permission = context.atom.permissions
                                .find_or_initialize_by(keeper: context.keeper,
                                                       actor: context.params[:actor])
    actions = if context.params[:actions].blank?
                {}
              else
                Hash[*context.params[:actions].map { |action| [action, true] }.flatten]
              end
    context.permission.assign_attributes(actions: actions)
    if context.permission.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.permission.errors.full_messages
    end
  end
end

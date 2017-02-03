class BeachApiCore::MembershipCreate
  include Interactor
  include BeachApiCore::Concerns::PolymorphicParamsConcern

  def call
    context.membership = context.group.memberships.build normalize_polymorphic_class(context.params)

    if context.membership.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.membership.errors.full_messages
    end
  end

end

class BeachApiCore::AtomUpdate
  include Interactor

  def call
    if context.atom.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.atom.errors.full_messages
    end
  end
end

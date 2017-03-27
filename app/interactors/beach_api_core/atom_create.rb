class BeachApiCore::AtomCreate
  include Interactor

  def call
    context.atom = BeachApiCore::Atom.new context.params

    if context.atom.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.atom.errors.full_messages
    end
  end
end

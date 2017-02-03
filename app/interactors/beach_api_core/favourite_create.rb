class BeachApiCore::FavouriteCreate
  include Interactor

  def call
    context.favourite = context.user.favourites.build(context.params)
    if context.favourite.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.favourite.errors.full_messages
    end
  end
end

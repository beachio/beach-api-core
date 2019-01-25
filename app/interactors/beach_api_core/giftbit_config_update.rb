class BeachApiCore::GiftbitConfigUpdate
  include Interactor

  def call
    context.params.delete(:giftbit_brands_attributes)
    unless context.giftbit_brands.blank?
      brands = {}
    end
    i = 0
    context.giftbit_brands.each do |brand|
      brands[i] = brand.to_h
      i += 1
    end
    context.params[:giftbit_brands_attributes] = brands
    context.giftbit_config.assign_attributes context.params
    if context.giftbit_config.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.giftbit_config.errors.full_messages
    end
  end
end
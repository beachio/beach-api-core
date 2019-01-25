class BeachApiCore::GiftbitConfigCreate
  include Interactor

  def call
    context.params.delete(:giftbit_brands_attributes)
    context.giftbit_config = BeachApiCore::GiftbitConfig.new context.params
    context.giftbit_config.application = context.application
    context.giftbit_brands.each do |brand|
      context.giftbit_config.giftbit_brands.new brand
    end
    if context.giftbit_config.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.giftbit_config.errors.full_messages
    end
  end
end
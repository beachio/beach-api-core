module BeachApiCore::Concerns::V1::Ownerable
  def get_customer
    customer=get_stripe_customer(current_owner).to_h.except(:subscriptions)
    render_json_success({customer:customer}, :ok) if customer
    rescue Stripe::InvalidRequestError => e
      render_json_error({:message => e.message})
  end

  def create_customer
    render_json_error({:message => "customer already exist"}) && return if customer_token(current_owner).present?
    unless current_owner.nil?
      card_token = Stripe::Token.create({card: card_params.to_h})
      customer = Stripe::Customer.create({email: current_owner.email, card: card_token.id}.merge(customer_creation_params.to_h))
      is_organisation?(current_owner) ? current_owner.update(:stripe_customer_token => customer.id) : current_owner.create_stripe_customer( customer.id, doorkeeper_token.application_id)
      render_json_success(:message => "Customer created successfully")
    else
      render_json_error(:message => "User or organisation not found")
    end
  rescue Stripe::CardError
    render_json_error({:message => "Wrong card"})
  end

  def delete_customer
    begin
      responce = Stripe::Customer.delete(customer_token(current_owner))
      is_organisation?(current_owner) ? current_owner.update_attribute('stripe_customer_token',nil) : current_owner.destroy_stripe_customer(customer_token(current_owner), doorkeeper_token.application_id)
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def update_customer
    begin
      responce = Stripe::Customer.update(customer_token(current_owner), customer_params.to_h)
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def all_cards
    begin
      responce = Stripe::Customer.list_sources(customer_token(current_owner),{object: 'card', limit: 10})
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def add_card
    begin
    card_token = Stripe::Token.create({card: card_params.to_h})
    responce = Stripe::Customer.create_source(customer_token(current_owner), {source: card_token.id})
    render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def update_card
    begin
      responce = Stripe::Customer.update_source(customer_token(current_owner),params[:card_id], update_card_params.to_h)
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def delete_card
    begin
      responce = Stripe::Customer.delete_source(customer_token(current_owner), params[:card_id])
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def all_payment_methods
    begin
      responce = Stripe::PaymentMethod.list({customer: customer_token(current_owner),type: 'card' })
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def add_payment_method
    begin
      payment_id = Stripe::PaymentMethod.create({type: 'card',card: card_params.to_h }).id
      responce = Stripe::PaymentMethod.attach(payment_id,{customer: customer_token(current_owner)})
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def update_payment_method
    begin
      responce = Stripe::PaymentMethod.update(params[:payment_method_id],payment_method_params.to_h)
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def detach_payment_method
    begin
      responce = Stripe::PaymentMethod.detach(params[:payment_method_id])
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def set_default_payment_method
    begin
      responce=Stripe::Customer.update(customer_token(current_owner), {invoice_settings: {default_payment_method: params[:payment_method_id]}})
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def subscription
    begin
      render_json_success(current_owner.subscription, :ok, serializer: BeachApiCore::SubscriptionSerializer, root: :subscription)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  private

  def get_stripe_customer(current_owner)
    Stripe::Customer.retrieve(customer_token(current_owner))
  end

  def set_stripe_key
    Stripe.api_key = stripe_in_test_mode? ? ENV['TEST_STRIPE_SECRET_KEY'] : ENV['LIVE_STRIPE_SECRET_KEY']
  end

  def customer_empty?
    render_json_error({:message => "customer does not exist"}) unless customer_token(current_owner).present?
  end

  def customer_token(owner)
    is_organisation?(owner) ? owner.stripe_customer_token : owner.stripe_token(doorkeeper_token.application_id)&.stripe_customer_token
  end

  def current_owner
    if self.class.name == "BeachApiCore::V1::UsersController"
      return current_user
    else
      return organisation_as_owner
    end
  end

  def stripe_in_test_mode?
    if self.class.name == "BeachApiCore::V1::UsersController"
      return doorkeeper_token.application.test_stripe
    else
      return organisation_as_owner.application.test_stripe
    end
  end

  def card_params
    params.require(:card_params).permit(:number, :exp_month, :exp_year, :cvc, :address_city, :address_country,
                                        :address_line1, :address_line2, :address_state, :address_zip)
  end

  def update_card_params
    params.require(:card_params).permit(:exp_month, :exp_year)
  end

  def customer_creation_params
    params.permit(:description, :email, :metadata, :name, :phone, :balance,
                                   address:[:line1, :city, :country, :line2, :postal_code, :state],
                                   invoice_settings:[:custom_fields, :default_payment_method, :footer],
                                   shipping:[:address,:name,:phone])
  end

  def payment_method_params
    params.permit(:metadata,card:[:exp_month,:exp_year],billing_details:[:email,:name,:phone,address:[:line1, :city, :country, :line2, :postal_code, :state]])
  end

  def customer_params
    params.require(:customer_params).permit(:description, :default_source, :email, :metadata, :name, :phone, :balance,
                                            address:[:line1, :city, :country, :line2, :postal_code, :state],
                                            invoice_settings:[:custom_fields, :default_payment_method, :footer],
                                            shipping:[:address,:name,:phone])
  end

  def organisation_as_owner
    owner = BeachApiCore::Organisation.find(params[:id])
    render_json_error({:message => "You are not authorized to make this request"}) and return unless owner.owners.include?(current_user) ||
        owner.assignments.admins.map(&:user_id).include?(current_user.id)
    return owner
  end

  def is_organisation?(owner)
    owner.class.name == 'BeachApiCore::Organisation'
  end
end

module BeachApiCore::Concerns::V1::Ownerable
  def get_customer
    customer=get_stripe_customer.to_h.except(:subscriptions)
    render_json_success({customer:customer}, :ok) if customer
    rescue Stripe::InvalidRequestError => e
      render_json_error({:message => e.message})
  end

  def create_customer
    render_json_error({:message => "customer already exist"}) && return if current_owner.stripe_customer_token.present?
    unless current_owner.nil?
      card_token = Stripe::Token.create({card: card_params.to_h})
      customer = Stripe::Customer.create({email: current_owner.email, card: card_token.id}.merge(customer_creation_params.to_h))
      current_owner.update_attribute(:stripe_customer_token, customer.id)
      render_json_success(:message => "Customer created successfully")
    else
      render_json_error(:message => "User or organisation not found")
    end
  rescue Stripe::CardError
    render_json_error({:message => "Wrong card"})
  end

  def delete_customer
    begin
      responce = Stripe::Customer.delete(current_owner.stripe_customer_token)
      current_owner.update_attribute('stripe_customer_token',nil)
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def update_customer
    begin
      responce = Stripe::Customer.update(current_owner.stripe_customer_token,customer_params.to_h)
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def all_cards
    begin
      responce = Stripe::Customer.list_sources(current_owner.stripe_customer_token,{object: 'card', limit: 10})
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def add_card
    begin
    card_token = Stripe::Token.create({card: card_params.to_h})
    responce = Stripe::Customer.create_source(current_owner.stripe_customer_token, {source: card_token.id})
    render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def update_card
    begin
      responce = Stripe::Customer.update_source(current_owner.stripe_customer_token,params[:card_id],card_params.to_h)
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def delete_card
    begin
      responce = Stripe::Customer.delete_source(current_owner.stripe_customer_token, params[:card_id])
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def all_payment_methods
    begin
      responce = Stripe::PaymentMethod.list({customer: current_owner.stripe_customer_token,type: 'card' })
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def add_payment_method
    owner=current_owner
    begin
      payment_id = Stripe::PaymentMethod.create({type: 'card',card: card_params.to_h }).id
      responce = Stripe::PaymentMethod.attach(payment_id,{customer: current_owner.stripe_customer_token})
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
      responce=Stripe::Customer.update(current_owner.stripe_customer_token,{invoice_settings: {default_payment_method: params[:payment_method_id]}})
      render_json_success(responce, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  def subscription
    begin
      responce = Stripe::Subscription.retrieve(current_owner.subscription.stripe_subscription_id)
      render_json_success(responce.to_h, :ok)
    rescue => e
      render_json_error({:message => e.message})
    end
  end

  private

  def get_stripe_customer
    Stripe::Customer.retrieve(current_owner.stripe_customer_token)
  end

  def set_stripe_key
    current_owner&.subscription&.plan&.test ? ENV['TEST_STRIPE_SECRET_KEY'] : ENV['LIVE_STRIPE_SECRET_KEY']
  end

  def customer_empty?
    render_json_error({:message => "customer does not exist"}) unless current_owner.stripe_customer_token.present?
  end

  def current_owner
    if self.class.name == "BeachApiCore::V1::UsersController"
      owner = BeachApiCore::User.find(params[:id])
      render_json_error({:message => "You are not authorized to make this request"}) and return if params[:id]!=current_user.id
      return owner
    else
      owner = BeachApiCore::Organisation.find(params[:id])
      render_json_error({:message => "You are not authorized to make this request"}) and return unless owner.owners.include?(current_user)
      return owner
    end
  end

  def card_params
    params.require(:card_params).permit(:number, :exp_month, :exp_year, :cvc, :address_city, :address_country,
                                        :address_line1, :address_line2, :address_state, :address_zip)
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
    params.require(:customer_params).permit(:description, :email, :metadata, :name, :phone, :balance,
                                            address:[:line1, :city, :country, :line2, :postal_code, :state],
                                            invoice_settings:[:custom_fields, :default_payment_method, :footer],
                                            shipping:[:address,:name,:phone])
  end
end

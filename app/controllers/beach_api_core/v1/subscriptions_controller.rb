module BeachApiCore
  class V1::SubscriptionsController < BeachApiCore::V1::BaseController
    include SubscriptionsDoc

    before_action :doorkeeper_authorize!
    skip_before_action :doorkeeper_authorize!, only: :invoice_created

    resource_description do
      name I18n.t('api.resource_description.resources.subscriptions')
    end

    def create
      unless subscription_params[:owner_id].nil?
        keeper = subscription_params[:subscription_for] == "user" ? current_user : BeachApiCore::Organisation.find_by(:id => subscription_params[:owner_id])
      end
      if keeper.nil?
        render_json_error({message: "Failed subscription creation"})
      else
        params[:subscription].delete(:subscription_for)
        params[:subscription].delete(:organisation_id)
        result = SubscriptionCreate.call(params: subscription_params,
                                         owner: keeper)
        if result.success?
          render_json_success(result.subscription,:ok, serializer: BeachApiCore::SubscriptionSerializer, root: :subscription)
        else
          render_json_error({ message: result.message }, result.status)
        end
      end
    end

    def update
      subs = BeachApiCore::Subscription.find_by(id: params[:id])
      if subs.nil?
        render_json_error({message: "Not Found"})
      else
        if admin || current_user.subscription.id == subs.id
          result = BeachApiCore::SubscriptionUpdate.call(:subscription => subs, :params => subscription_update_params)
          keeper = subs.keeper_type=="BeachApiCore::Organisation" ? BeachApiCore::Organisation.find_by(:id => subs.keeper_id) : BeachApiCore::User.find_by(:id => subs.keeper_id)
          keeper.invoices.create(:invoice_url_link => invoice.hosted_invoice_url, :invoice_pdf_link => invoice.invoice_pdf)
          if result.success?
            render_json_success(result.subscription, result.status, serializer: BeachApiCore::SubscriptionSerializer, root: :subscription)
          else
            render_json_error({ message: result.message }, result.status)
          end
        else
          render_json_error({message: "Wrong Access"})
        end
      end
    end


    def show
      subs = BeachApiCore::Subscription.find_by(id: params[:id])
      if subs.nil?
        render_json_error({message: "Not Found"})
      else
        if admin || current_user.subscription.id == subs.id
          render_json_success(subs,:ok, serializer: BeachApiCore::SubscriptionSerializer, root: :subscription)
        else
          render_json_error({message: "Wrong Access"})
        end
      end

    end

    def destroy
      subs = BeachApiCore::Subscription.find_by(id: params[:id])
      if subs.nil?
        render_json_error({message: "Not Found"})
      else
       if admin || current_user.subscription.id == subs.id
         if subs.destroy
           head :no_content
         else
           render_json_error({message: "Can't delete subscription"})
         end
       else
         render_json_error({message: "Wrong Access"})
       end
      end
    end

    def create_customer
      set_stripe_key
      client = subscription_params[:subscription_for]=="user" ? current_user : BeachApiCore::Organisation.find_by(:id => subscription_params[:owner_id])
      unless client.nil?
        card_token = Stripe::Token.create(
          {
            card: {
              number: card_params[:number],
              exp_month: card_params[:exp_month],
              exp_year: card_params[:exp_year],
              cvc: card_params[:cvc]
            }
          }
        )
        customer = Stripe::Customer.create(email: client.email, card: card_token.id)
        client.update_attribute(:stripe_customer_token, customer.id)
        render_json_success(:message => "Customer created successfully")
      else
        render_json_error(:message => "User or organisation not found")
      end
    rescue Stripe::CardError => e
      render_json_error({:message => "Wrong card"})
    end

    def show_invoices
      owner_type = params[:user_id].present? ? "BeachApiCore::User" : "BeachApiCore::Organisation"
      keeper = owner_type=="BeachApiCore::User" ? BeachApiCore::User.find_by(:id => params[:user_id]) : BeachApiCore::Organisation.find_by(:id => params[:organisation_id])
      if owner_type=="BeachApiCore::User" && keeper.id == current_user.id
        subs = BeachApiCore::Subscription.find_by(id: params[:id], owner_type: owner_type, :owner_id => keeper.id)
      elsif owner_type=="BeachApiCore::Organisation" && keeper.organisations.where(:id => params[:organisation_id]).include?(current_user)
        subs = BeachApiCore::Subscription.find_by(id: params[:id], owner_type: owner_type, :owner_id => keeper.id)
      end
      unless subs.nil?
        invoices = BeachApiCore::Invoice.where(subscription_id: subs.id)
        if invoices.empty?
          render_json_error(message: "Invoices not found")
        else
          render_json_success(invoices)
        end
      else
        render_json_error(message: "Wrong subscription")
      end
    rescue
      render_json_error(message: "Wrong request")
    end

    def update_quantity
      unless params[:id].nil?
        subs = BeachApiCore::Subscription.find_by(:id => params[:id])
        Stripe.api_key = subs.plan.test ? ENV['TEST_STRIPE_SECRET_KEY'] : ENV['LIVE_STRIPE_SECRET_KEY']
        stripe_subs = Stripe::Subscription.retrieve(subs.stripe_subscription_id)
        unless subs.nil? || stripe_subs.nil?
          quantity = subs.get_quantity
          unless stripe_subs.items.data[0].quantity == quantity
            not_owner = !BeachApiCore::Membership.pluck(:owner, :group_type, :group_id, :member_type, :member_id).include?([true,subs.owner_type,subs.owner_id,"BeachApiCore::User",current_user.id])
            not_admin = !BeachApiCore::Assignment.pluck(:user_id ,:role_id ,:keeper_id ,:keeper_type).include?([current_user.id,1,subs.owner_id,subs.owner_type])
            unless not_owner || not_admin
              Stripe::SubscriptionItem.update(stripe_subs.items.data[0].id, {plan: stripe_subs.items.data[0].plan.id, quantity: quantity})
              subs.create_invoice
              render_json_success(:message => "Subscription updated successfully")
            else
              render_json_error(:message => "Wrong access")
            end
          else
            render_json_error(:message => "Quantity not changed")
          end
        else
          render_json_error(:message => "Wrong subscription")
        end
      else
        render_json_error({:message => "Wrong id"})
      end
    rescue
      render_json_error(message: "Wrong request")
    end

    private

    def subscription_params
      params.require(:subscription).permit(:plan_id, :subscription_for, :owner_id)
    end

    def subscription_update_params
      params.require(:subscription).permit(:plan_id)
    end

    def card_params
      params.require(:card_params).permit(:number, :exp_month, :exp_year, :cvc)
    end

    def have_subscription
      !current_user.plan.nil?
    end

    def set_stripe_key
      Stripe.api_key = self.plan.test ? ENV['TEST_STRIPE_SECRET_KEY'] : ENV['LIVE_STRIPE_SECRET_KEY']
    end
  end
end
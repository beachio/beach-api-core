module BeachApiCore
  class V1::SubscriptionsController < BeachApiCore::V1::BaseController
    include SubscriptionsDoc

    before_action :doorkeeper_authorize!
    skip_before_action :doorkeeper_authorize!, only: :invoice_created

    resource_description do
      name I18n.t('api.resource_description.resources.subscriptions')
    end

    def create
      if subscription_params[:subscription_for] == "user"
        keeper = current_user
      elsif subscription_params[:subscription_for] == "organisation" && !subscription_params[:organisation_id].nil?
        keeper = BeachApiCore::Organisation.find_by(:id => subscription_params[:organisation_id])
        keeper = nil if !keeper.nil? && keeper.owners.include?(current_user)
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
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
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
      customer = Stripe::Customer.create(email: current_user.email, card: card_token.id)
      current_user.update_attribute(:stripe_customer_token, customer.id)
      render_json_success(:message => "Customer created successfully")
    rescue Stripe::CardError => e
      render_json_error({:message => "Wrong card"})
    end

    private

    def subscription_params
      params.require(:subscription).permit(:plan_id, :subscription_for, :organisation_id)
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
  end
end
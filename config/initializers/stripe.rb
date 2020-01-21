StripeEvent.signing_secret = ENV['Stripe_Webhook_Key'] # e.g. whsec_...

StripeEvent.configure do |events|
  events.all Stripe::InvoiceEventHandler.new
end
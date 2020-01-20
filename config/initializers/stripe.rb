StripeEvent.signing_secret = "whsec_DdKmsdowdYllbFOcLOqhmmHNFmuT1bgG" # e.g. whsec_...

StripeEvent.configure do |events|
  events.all Stripe::InvoiceEventHandler.new
end
module Stripe
  class InvoiceEventHandler
    def call(event)
        method = "handle_" + event.type.tr('.', '_')
        self.send(method, event)
    end

    def handle_invoice_payment_failed(event)
      create_invoice(event)

    end

    def handle_invoice_payment_succeeded(event)
      create_invoice(event)
    end

    private

    def create_invoice(event)
      object=event.data.object
      subscription=BeachApiCore::Subscription.find_by(stripe_subscription_id:object.subscription)
      BeachApiCore::Invoice.create(invoice_url_link:object.hosted_invoice_url,
                                   invoice_pdf_link:object.invoice_pdf,
                                   keeper_type:subscription&.owner_type,
                                   keeper_id:subscription&.owner_id,
                                   subscription_id:subscription&.id,
                                   payment_successfull:object.paid)

    end
  end
end
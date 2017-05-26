require 'rails_helper'

module BeachApiCore
  describe WebhooksNotifier do
    describe '#send_notification' do
      Webhook.kinds.keys.each do |webhook_kind|
        let!(:"#{webhook_kind}_webhook") { create(:webhook, kind: webhook_kind) }
      end

      Webhook.kinds.keys.each do |webhook_kind|
        before do
          @webhook = send("#{webhook_kind}_webhook")
          stub_request(:post, @webhook.uri).to_return(status: 200)
        end

        it "should send #{webhook_kind} notification" do
          subject.perform(webhook_kind)
          expect(a_request(:post, @webhook.uri).with(body: { event: webhook_kind })).to have_been_made.once
        end
      end
    end
  end
end

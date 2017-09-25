require 'rails_helper'

module BeachApiCore
  describe WebhooksNotifier do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    before { access_token.update(organisation: (create :organisation)) }
    describe '#send_notification' do
      Webhook.kinds.keys.each do |webhook_kind|
        let!(:"#{webhook_kind}_webhook") { create(:webhook, kind: webhook_kind) }
      end

      context 'user_created' do
        before do
          stub_request(:post, user_created_webhook.uri).to_return(status: 200)
          @user = create(:user)
        end

        it 'should send user_created notification' do
          subject.perform('user_created', @user.class.name, @user.id, access_token.id)
          serialized_user = UserSerializer.new(@user)
          expect(a_request(:post, user_created_webhook.uri)
                     .with(body: { event: 'user_created', model: serialized_user }.to_json)).to have_been_made.once
        end
      end

      context 'team_created' do
        before do
          stub_request(:post, team_created_webhook.uri).to_return(status: 200)
          @team = create(:team)
        end

        it 'should send user_created notification' do
          subject.perform('team_created', @team.class.name, @team.id, access_token.id)
          serialized_team = TeamSerializer.new(@team)
          expect(a_request(:post, team_created_webhook.uri)
                     .with(body: { event: 'team_created', model: serialized_team }.to_json)).to have_been_made.once
        end
      end

      context 'organisation_created' do
        before do
          stub_request(:post, organisation_created_webhook.uri).to_return(status: 200)
          @organisation = create(:organisation)
        end

        it 'should send user_created notification' do
          subject.perform('organisation_created', @organisation.class.name, @organisation.id, access_token.id)
          serialized_organisation = OrganisationSerializer.new(@organisation)
          expect(a_request(:post, organisation_created_webhook.uri)
                   .with(body: { event: 'organisation_created', model: serialized_organisation }.to_json))
            .to have_been_made.once
        end
      end
    end
  end
end

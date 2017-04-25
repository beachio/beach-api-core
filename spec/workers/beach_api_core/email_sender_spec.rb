require 'rails_helper'

module BeachApiCore
  describe EmailSender do
    describe 'should send an email' do
      before do
        content = Faker::Lorem.sentence
        @email_params = {
          from: Faker::Internet.email,
          to: Faker::Internet.email,
          cc: Faker::Internet.email,
          subject: Faker::Lorem.sentence,
          body: "<body>#{content}</body>",
          plain: content
        }
      end

      it do
        expect { subject.perform(@email_params) }.to change(ActionMailer::Base.deliveries, :size).by(1)
        expect(ActionMailer::Base.deliveries.first.to).to eq [@email_params[:to]]
      end
    end
  end
end

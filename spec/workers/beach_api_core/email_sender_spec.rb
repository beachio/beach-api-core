require 'rails_helper'

module BeachApiCore
  describe EmailSender do
    let(:application) { create :oauth_application }
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

    describe 'should send an email' do
      it do
        expect { subject.perform(application.id, @email_params) }.to change(ActionMailer::Base.deliveries, :size).by(1)
        expect(ActionMailer::Base.deliveries.last.to).to eq [@email_params[:to]]
      end
    end

    context 'template params' do
      let(:template_params) { { first_name: Faker::Name.first_name } }

      before do
        @template = create :template, value: 'Hello, {first_name}', name: SecureRandom.hex
        allow_any_instance_of(TemplateParser).to receive(:email_first_name).and_return(template_params[:first_name])
      end

      it 'should raise an error' do
        expect { subject.perform(application.id, @email_params.merge(template: Faker::Lorem.word)) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should set correct body from template' do
        subject.perform(application.id, @email_params.merge(template: @template.name,
                                                         template_params: template_params))
        expect(ActionMailer::Base.deliveries.last.text_part.body.to_s).to eq("Hello, #{template_params[:first_name]}")
      end
    end
  end
end

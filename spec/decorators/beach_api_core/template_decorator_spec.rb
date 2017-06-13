require 'rails_helper'

module BeachApiCore
  describe BeachApiCore::TemplateDecorator do
    describe '#pretty_value' do
      context 'with interaction' do
        let(:interaction) { create(:interaction) }
        let(:template_params) { { first_name: Faker::Name.first_name } }
        let(:template) { create(:template, name: interaction.kind, value: 'Hello, {first_name}') }
        before do
          allow_any_instance_of(TemplateParser)
            .to receive(:"#{template.kind}_first_name").and_return(template_params[:first_name])
        end

        it 'should return correct value' do
          expect(template.decorate.pretty_value(interaction)).to eq "Hello, #{template_params[:first_name]}"
        end
      end

      context 'without interaction' do
        let(:template) { create(:template) }

        it 'should return empty string' do
          expect(template.decorate.pretty_value(nil)).to eq ''
        end
      end
    end
  end
end

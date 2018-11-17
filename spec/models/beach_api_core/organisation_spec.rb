require 'rails_helper'

module BeachApiCore
  describe Organisation, type: :model do
    subject { build(:organisation) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations and basic validations' do
      should validate_presence_of :name
      should validate_presence_of :application
      should belong_to :application
      should have_many :users
      should have_one :organisation_plan
      should have_one :plan
      should have_many :teams
      should have_many :invitations
      should have_one :logo_image
      should have_many :assignments
      should have_many :projects
      should have_many :user_accesses
      should respond_to :send_email
    end

    describe 'generate image' do
      let!(:organisation) { create :organisation }

      it 'should generate logo image if logo_image is blank' do
        expect(create(:organisation, logo_image: nil).logo_image).to be_present
      end

      it 'should generate new logo image if organisation name was changed' do
        expect { organisation.update(name: Faker::Job.title) }.to change(organisation, :logo_image)
      end

      it 'should generate new logo image if organisation logo properties were changed' do
        expect do
          organisation.update(logo_properties: { color: Faker::Color.hex_color })
        end.to change(organisation, :logo_image)
      end

      it "shouldn't generate new logo image if it was set manually" do
        organisation.update(logo_image: build(:asset, entity: organisation))
        expect(organisation.logo_image).not_to be_generated
        expect { organisation.update(name: Faker::Job.title) }.not_to change(organisation, :logo_image)
        expect { organisation.update(name: Faker::Job.title) }.not_to change(organisation, :logo_image)
      end
    end
  end
end

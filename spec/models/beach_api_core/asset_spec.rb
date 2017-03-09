require 'rails_helper'

module BeachApiCore
  describe Asset, type: :model do
    subject { build(:asset) }

    it 'should be valid with basic factory attributes' do
      expect(build(:asset)).to be_valid
    end

    it 'should have basic validations' do
      should belong_to :entity
      should validate_presence_of :file
      should validate_presence_of :entity
    end

    it 'should grab file extension' do
      [:jpg, :jpeg, :bmp, :png, :gif, :doc, :docx, :xls, :xlsx, :pdf, :txt].each do |extension|
        asset = create :asset,
                       file: Refile::FileDouble.new('dummy', 'logo.png', content_type: 'image/png'),
                       file_filename: "filename.#{extension}"
        expect(asset.file_extension).to eq extension.to_s
      end
      expect(Asset.images.count).to eq 5
      expect(Asset.files.count).to eq 6
    end

    context 'asset with base64' do
      let(:base64) { "data:image/png;base64,#{Base64.encode64(File.read('spec/uploads/test.png'))}" }
      it 'should create' do
        expect { create :asset, base64: base64 }.to change(BeachApiCore::Asset, :count).by(1)
      end

      context 'filename' do
        it 'should generate filename' do
          asset = create(:asset, base64: base64)
          expect(asset.file_filename).to eq 'asset.png'
        end

        it 'should store provided filename' do
          filename = Faker::File.file_name
          asset = create(:asset, base64: base64, name: filename)
          expect(asset.file_filename).to eq filename
        end
      end
    end

  end
end

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
        asset = create :asset, file_filename: "filename.#{extension}"
        expect(asset.file_extension).to eq extension.to_s
      end
      expect(Asset.images.count).to eq 5
      expect(Asset.files.count).to eq 6
    end

  end
end

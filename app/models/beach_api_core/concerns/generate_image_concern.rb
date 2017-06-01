module BeachApiCore::Concerns::GenerateImageConcern
  extend ActiveSupport::Concern

  included do
    def generate_image(asset_field, options = {})
      background_color = options[:color] || '#FFF'
      canvas = Magick::Image.new(200, 200) { |image| image.background_color = background_color }
      gc = Magick::Draw.new do |draw|
        draw.pointsize = 150
        draw.gravity = Magick::CenterGravity
      end
      gc.text(0, 0, (name[/[a-zA-Z]/] || name.first).upcase)
      gc.draw(canvas)
      Tempfile.open(%w(logo .png)) do |file|
        canvas.write(file.path)
        file.rewind
        send("#{asset_field}=", BeachApiCore::Asset.new(file: file, generated: true))
      end
    end
  end
end

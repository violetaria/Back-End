class OCRFormatter

  def initialize()
  end

  def import_recipe(image)
    ocr_converter = RTesseract.new(image)
    ocr_converter.to_s.split("\n").select do |line|
      line.lstrip.rstrip.length > 0
    end
  end
end
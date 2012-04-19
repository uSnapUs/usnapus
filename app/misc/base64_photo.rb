class Base64Photo
  class FilelessIO < StringIO
    attr_accessor :original_filename
    attr_accessor :content_type
  end

  def self.base64_to_photo(encoded_img, original_filename, content_type)
    io = FilelessIO.new(Base64.decode64(encoded_img))
    io.original_filename = original_filename
    io.content_type = content_type
    io
  end
end
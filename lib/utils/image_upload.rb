require "securerandom"
require "uri"
require "cloudinary"

module ImageUpload
  MAX_SIZE = 5 * 1024 * 1024 # 5 MB

  # Magic byte signatures — checked against raw file bytes, not the filename.
  MIME_SIGNATURES = {
    "image/jpeg" => ->(b) { b[0..2]  == [0xFF, 0xD8, 0xFF] },
    "image/png"  => ->(b) { b[0..7]  == [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A] },
    "image/gif"  => ->(b) { b[0..2]  == [0x47, 0x49, 0x46] && b[3] == 0x38 &&
                             (b[4] == 0x37 || b[4] == 0x39) && b[5] == 0x61 },
    "image/webp" => ->(b) { b[0..3]  == [0x52, 0x49, 0x46, 0x46] &&
                             b[8..11] == [0x57, 0x45, 0x42, 0x50] },
  }.freeze

  # Accepts a Rack uploaded file hash and returns the Cloudinary HTTPS URL or nil.
  def self.save(file_hash)
    return nil unless file_hash.is_a?(Hash) && file_hash[:tempfile]

    tempfile = file_hash[:tempfile]
    return nil if tempfile.size > MAX_SIZE

    header = tempfile.read(12)
    tempfile.rewind
    return nil unless header && header.bytesize >= 3

    bytes = header.bytes
    mime  = MIME_SIGNATURES.find { |_, check| check.call(bytes) }&.first
    return nil unless mime

    result = Cloudinary::Uploader.upload(
      tempfile,
      resource_type: "image",
      public_id:     SecureRandom.hex(16)
    )
    result["secure_url"]
  rescue Cloudinary::Error
    nil
  end

  # Deletes a Cloudinary-hosted image by its stored URL.
  def self.delete(url)
    return unless url.is_a?(String) && url.include?("cloudinary.com")
    public_id = extract_public_id(url)
    return if public_id.to_s.empty?
    Cloudinary::Uploader.destroy(public_id)
  rescue Cloudinary::Error
    nil
  end

  def self.extract_public_id(url)
    # URL pattern: https://res.cloudinary.com/{cloud}/image/upload/v{ver}/{public_id}.{ext}
    File.basename(URI.parse(url).path, ".*")
  rescue URI::InvalidURIError
    nil
  end
  private_class_method :extract_public_id
end

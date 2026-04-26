require "securerandom"
require "fileutils"

module ImageUpload
  UPLOAD_DIR = File.join("public", "uploads").freeze
  MAX_SIZE   = 5 * 1024 * 1024 # 5 MB

  # Magic byte signatures — checked against the raw file bytes, not the filename.
  MIME_SIGNATURES = {
    "image/jpeg" => ->(b) { b[0..2]  == [0xFF, 0xD8, 0xFF] },
    "image/png"  => ->(b) { b[0..7]  == [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A] },
    "image/gif"  => ->(b) { b[0..2]  == [0x47, 0x49, 0x46] && b[3] == 0x38 &&
                             (b[4] == 0x37 || b[4] == 0x39) && b[5] == 0x61 },
    "image/webp" => ->(b) { b[0..3]  == [0x52, 0x49, 0x46, 0x46] &&
                             b[8..11] == [0x57, 0x45, 0x42, 0x50] },
  }.freeze

  EXT_FOR = {
    "image/jpeg" => ".jpg",
    "image/png"  => ".png",
    "image/gif"  => ".gif",
    "image/webp" => ".webp",
  }.freeze

  # Accepts a Rack uploaded file hash (from multipart form) and returns the public URL path
  # (e.g. "/uploads/abc123.jpg") or nil on validation failure.
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

    FileUtils.mkdir_p(UPLOAD_DIR)
    name = "#{SecureRandom.hex(16)}#{EXT_FOR[mime]}"
    dest = File.join(UPLOAD_DIR, name)
    File.binwrite(dest, tempfile.read)
    "/uploads/#{name}"
  end

  # Deletes a previously uploaded file given its public path.
  def self.delete(public_path)
    return unless public_path.is_a?(String) && public_path.start_with?("/uploads/")
    path = File.join("public", public_path.sub(%r{\A/}, ""))
    File.delete(path) if File.exist?(path)
  end
end

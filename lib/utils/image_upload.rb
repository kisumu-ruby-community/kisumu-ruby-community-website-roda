require "securerandom"
require "fileutils"

module ImageUpload
  UPLOAD_DIR  = File.join("public", "uploads").freeze
  ALLOWED_EXT = %w[.jpg .jpeg .png .gif .webp].freeze
  MAX_SIZE    = 5 * 1024 * 1024 # 5 MB

  # Accepts a Rack uploaded file hash (from multipart form) and returns the public URL path (e.g. "/uploads/abc123.jpg") or nil.
  def self.save(file_hash)
    return nil unless file_hash.is_a?(Hash) && file_hash[:tempfile]

    original = file_hash[:filename].to_s
    ext = File.extname(original).downcase
    return nil unless ALLOWED_EXT.include?(ext)
    return nil if file_hash[:tempfile].size > MAX_SIZE

    FileUtils.mkdir_p(UPLOAD_DIR)
    name = "#{SecureRandom.hex(16)}#{ext}"
    dest = File.join(UPLOAD_DIR, name)
    File.binwrite(dest, file_hash[:tempfile].read)
    "/uploads/#{name}"
  end

  # Deletes a previously uploaded file given its public path.
  def self.delete(public_path)
    return unless public_path.is_a?(String) && public_path.start_with?("/uploads/")
    path = File.join("public", public_path.sub(%r{\A/}, ""))
    File.delete(path) if File.exist?(path)
  end
end

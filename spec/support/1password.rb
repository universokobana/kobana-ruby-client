# frozen_string_literal: true

# begin
#   # do not change the default op:// string
#   # this is a default value to condition below be true when the env vars are not set
#   # and when the vars has the full path to the 1Password CLI
#   ENV.each do |key, value|
#     next unless value.include?("op://")

#     puts "Fetching #{key} from 1Password..."
#     ENV[key] = `op read "#{value}"`.strip
#   end
# rescue StandardError => _e
#   puts("\nError: Credentials not found in 1Password. Check if you have access to vault CLI at kobana.1password.com")
# end

class << ENV
  alias original_fetch fetch

  def fetch(key, *)
    value = original_fetch(key, *)
    ENV[key] = value.to_s.include?("op://") ? `op read "#{value}"`.strip : value.to_s
  end
end

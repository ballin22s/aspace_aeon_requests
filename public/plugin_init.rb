unless AppConfig.has_key? :aspace_aeon_requests_endpoint
  raise "Config variable :aspace_aeon_requests_endpoint is required!"
end

$stdout.puts "\n\n\nArchivesSpace Aeon requests plugin enabled =)\n\n\n"

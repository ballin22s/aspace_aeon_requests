# check for required config settings
[
  :aspace_aeon_requests_endpoint,
  :aspace_aeon_requests_repo_default,
].each do |config|
  unless AppConfig.has_key? config
    raise "Config variable #{config} is required!"
  end
end

unless AppConfig.has_key? :aspace_aeon_requests_repo_map
  AppConfig[:aspace_aeon_requests_repo_map] = {}
end

$stdout.puts "\n\n\nArchivesSpace Aeon requests plugin enabled =)\n\n\n"

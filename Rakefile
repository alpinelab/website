LOCALEAPP_CONFIG      = ".localeapp/config.rb".freeze
LOCALEAPP_CONFIG_DIR  = LOCALEAPP_CONFIG.pathmap("%d").freeze
CI_SERVICE_ENV_KEY    = "TRAVIS".freeze


directory LOCALEAPP_CONFIG_DIR

file LOCALEAPP_CONFIG => LOCALEAPP_CONFIG_DIR do |t|
  # FIXME: maybe it would be better to improve localeapp setup, or test env
  # management, rather than creating a dummy config file.
  #sh "touch #{t.name}" if ENV.key? CI_SERVICE_ENV_KEY
  next unless ENV.key? CI_SERVICE_ENV_KEY
  File.open t.name, "w" do |f|
    f.write <<-eoh
Localeapp.configure do |config|
  config.api_key                    = 'DUMMY_KEY_FOR_TESTS'
  config.translation_data_directory = 'locales'
end
    eoh
  end
end


task default: :test

desc "Test middleman build"
task test: LOCALEAPP_CONFIG do
  sh "bundle exec middleman build"
end

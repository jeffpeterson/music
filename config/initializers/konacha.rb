Konacha.configure do |config|
  require 'capybara/poltergeist'
  config.spec_dir     = 'app/assets/javascripts'
  config.spec_matcher = 'spec.js.coffee'
  config.driver       = :poltergeist
end if defined?(Konacha)

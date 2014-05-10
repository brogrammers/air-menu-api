Apipie.configure do |config|
  config.app_name                = "AirMenu-Api"
  config.copyright               = "&copy; #{Time.now.year} AirMenu"
  config.default_version         = "v1"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/docs"
  config.validate                = true
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.namespaced_resources    = true
  config.app_info                = "AirMenu REST API documentation"
  config.use_cache               = Rails.env.production?
end
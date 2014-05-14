DsCabinetWidgets::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # UAS settings
  config.uas_url = 'https://pim.sredda.ru:4443/authentication'
  config.uas_sertificate = "#{Rails.root}/certs/ds_admin.pem"
  config.uas_query_log = true
  config.uas_curl_verbose = true

  # PIM settings
  config.pim_url = 'https://pim.sredda.ru:4443/'
  config.pim_server = 'https://pim.sredda.ru:4443/'
  config.pim_sertificate = "#{Rails.root}/certs/ds_admin.pem"
  # config.pim_server = 'https://ccdemopim.sredda.ru:5443/'
  config.pim_product_offerings = ['5336743']
  config.pim_product_url = 'http://dsstore.dasreda.ru/'
  # config.pim_product_offerings = ['5215886']
  config.pim_query_log = true
  config.pim_curl_verbose = true

  # CART settings
  config.cart_url = 'http://cart.sredda.ru'
  config.cart_sertificate = "#{Rails.root}/certs/ds_admin.pem"
  config.cart_summary_url = 'http://cart.sredda.ru/api/items/summary'
  config.cart_merchant_id = '100004'
  config.cart_merchant_password = 'password4'
  config.cart_query_log = true
  config.cart_curl_verbose = true

  # CABINET settings
  config.cabinet_url = 'http://dev-delo.sredda.ru'
  config.cabinet_curl_verbose = true

  config.widget_domain = 'local.sredda.ru:3000'

  # Authentication settings
  config.auth_domain = '.sredda.ru'

end

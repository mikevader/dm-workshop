Recaptcha.configure do |config|
    config.site_key  = '10000000-ffff-ffff-ffff-000000000001'
    config.secret_key = '0x0000000000000000000000000000000000000000'
    config.verify_url = 'https://hcaptcha.com/siteverify'
    config.api_server_url = 'https://hcaptcha.com/1/api.js'
    config.response_limit = 100000
  end

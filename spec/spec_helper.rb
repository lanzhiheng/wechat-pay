# frozen_string_literal: true

require 'openssl'
require 'json'
require 'wechat-pay'

WechatPay.configure do |config|
  config.app_id = 'wxd930ea5d5a258f4f'
  config.mch_key = '8934e7d15453e97507ef794cf7b0519d'
  config.mch_id = '16000000'
  config.apiclient_key = File.read('spec/fixtures/random_apiclient_key.pem')
  config.apiclient_cert = File.read('spec/fixtures/random_apiclient_cert.pem')
  config.platform_cert = File.read('spec/fixtures/random_platform_cert.pem')
end

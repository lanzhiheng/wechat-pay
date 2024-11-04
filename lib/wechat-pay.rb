# rubocop:disable Naming/FileName

# frozen_string_literal: true

require 'restclient'
require 'wechat-pay/sign'
require 'wechat-pay/direct' # 直连模式
require 'wechat-pay/ecommerce' # 电商平台
require 'wechat-pay/config'
require 'wechat-pay/client'
require 'wechat-pay/helper'

# # 微信支付
#
# 设置关键信息
module WechatPay
  class << self
    attr_reader :client, :config, :direct, :ecommerce, :sign

    delegate :app_id, :mch_id, :mch_key, :apiclient_key, :apiclient_cert, :platform_cert, :platform_serial_no, :apiclient_serial_no, to: :config

    def configure
      @config = WechatPay::Config.new
      yield config

      @client = WechatPay::Client.new(config)
      @direct = WechatPay::Direct::Direct.new(config)
      @ecommerce = WechatPay::Ecommerce::Ecommerce.new(config)
      @sign = WechatPay::Sign.new(config)
    end
  end
end
# rubocop:enable Naming/FileName

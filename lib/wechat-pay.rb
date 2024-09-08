# rubocop:disable Naming/FileName

# frozen_string_literal: true

require 'restclient'
require 'wechat-pay/sign'
require 'wechat-pay/direct' # 直连模式
require 'wechat-pay/ecommerce' # 电商平台
require 'wechat-pay/config'

# # 微信支付
#
# 设置关键信息
module WechatPay
  autoload :YopConfig, 'wechat-pay/config'
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Config.new
    end
  end
end
# rubocop:enable Naming/FileName

# rubocop:disable Naming/FileName

# frozen_string_literal: true

require 'restclient'
require 'wechat-pay/sign'
require 'wechat-pay/direct' # 直连模式
require 'wechat-pay/ecommerce' # 电商平台

# # 微信支付
#
# 设置关键信息
module WechatPay
  class << self
    attr_accessor :app_id, :mch_id, :mch_key
    attr_reader :apiclient_key, :apiclient_cert, :platform_cert

    # 设置商户私钥，从微信商户平台下载
    def apiclient_key=(key)
      @apiclient_key = OpenSSL::PKey::RSA.new(key)
    end

    # 设置平台证书，通过接口获取 https://github.com/lanzhiheng/wechat-pay/blob/master/lib/wechat-pay/ecommerce/applyment.rb#L116
    def platform_cert=(cert)
      @platform_cert = OpenSSL::X509::Certificate.new(cert)
    end

    # 设置商户证书，从微信商户平台下载
    def apiclient_cert=(cert)
      @apiclient_cert = OpenSSL::X509::Certificate.new(cert)
    end

    # 平台证书序列号
    def platform_serial_no
      @platform_serial_no ||= platform_cert.serial.to_s(16)
    end

    # 商户证书序列号
    def apiclient_serial_no
      @apiclient_serial_no ||= apiclient_cert.serial.to_s(16)
    end
  end
end
# rubocop:enable Naming/FileName

# frozen_string_literal: true

require 'restclient'
require 'wechat_pay/sign'
require 'wechat_pay/ecommerce'

module WechatPay
  class<< self
    attr_accessor :appid, :mch_id, :mch_key
    attr_reader :apiclient_key, :apiclient_cert, :platform_cert

    def apiclient_key=(key)
      @apiclient_key = OpenSSL::PKey::RSA.new(key)
    end

    def platform_cert=(cert)
      @platform_cert = OpenSSL::X509::Certificate.new(cert)
    end

    def apiclient_cert=(cert)
      @apiclient_cert = OpenSSL::X509::Certificate.new(cert)
    end

    def platform_serial_no
      @platform_serial_no ||= platform_cert.serial.to_s(16)
    end

    def apiclient_serial_no
      @apiclient_serial_no ||= apiclient_cert.serial.to_s(16)
    end
  end
end

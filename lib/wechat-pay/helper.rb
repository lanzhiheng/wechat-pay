# frozen_string_literal: true

require 'active_support/concern'

module WechatPayHelper # :nodoc:
  GATEWAY_URL = 'https://api.mch.weixin.qq.com'

  extend ActiveSupport::Concern

  class_methods do
    def build_query(params)
      params.sort.map { |key, value| "#{key}=#{value}" }.join('&')
    end

    def make_request(method:, path:, for_sign: '', payload: {}, extra_headers: {}, &block)
      authorization = WechatPay::Sign.build_authorization_header(method, path, for_sign, &block)
      headers = {
        'Authorization' => authorization,
        'Content-Type' => 'application/json',
        'Accept-Encoding' => '*'
      }.merge(extra_headers)
      RestClient::Request.execute(
        url: "#{GATEWAY_URL}#{path}",
        method: method.downcase,
        payload: payload,
        headers: headers.compact # Remove empty items
      )
    rescue ::RestClient::ExceptionWithResponse => e
      e.response
    end
  end

  class << self
    def fetch_or_default_config(&block)
      config = WechatPay.config
      config = block.call if block_given?
      config
    end
  end
end

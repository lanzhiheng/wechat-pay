# frozen_string_literal: true

require 'active_support/concern'

module WechatPayHelper # :nodoc:
  extend ActiveSupport::Concern

  class_methods do
    def build_query(params)
      WechatPay.client.build_query(params)
    end

    def make_request(method:, path:, for_sign: '', payload: {}, extra_headers: {})
      WechatPay.client.make_request(method: method, path: path, for_sign: for_sign, payload: payload, extra_headers: extra_headers)
    end
  end
end

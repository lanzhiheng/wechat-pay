# frozen_string_literal: true

require 'json'
require 'wechat-pay/direct/direct'

module WechatPay
  # # 直连商户相关接口封装（常用的已有，待完善）
  # 文档: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_1.shtml
  module Direct
    %w[
      invoke_transactions_in_js invoke_transactions_in_miniprogram invoke_transactions_in_app invoke_transactions_in_h5 invoke_transactions_in_native
      invoke_combine_transactions_in_app invoke_combine_transactions_in_js invoke_combine_transactions_in_h5 invoke_combine_transactions_in_miniprogram invoke_combine_transactions_in_native
      query_combine_order close_combine_order query_order close_order invoke_refund query_refund
      tradebill fundflowbill direct_transactions_method_by_suffix
    ].each do |method_name|
      define_singleton_method(method_name) do |*args|
        WechatPay.direct.send(method_name, *args)
      end
    end
  end
end

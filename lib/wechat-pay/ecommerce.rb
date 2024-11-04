# frozen_string_literal: true

require 'wechat-pay/ecommerce/ecommerce'
module WechatPay
  # # 服务商相关接口封装（电商平台，服务商有许多接口共用）
  # 文档: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/open/pay/chapter3_3_3.shtml
  #
  # PS: 电商收付通的所有接口已经封装完毕，有需要再补充。
  #
  module Ecommerce
    %w[
      applyment query_applyment certificates query_settlement modify_settlement
      query_realtime_balance query_endday_balance query_platform_realtime_balance query_platform_endday_balance
      tradebill fundflowbill ecommerce_fundflowbill
      invoke_combine_transactions_in_js invoke_combine_transactions_in_h5 invoke_combine_transactions_in_native invoke_combine_transactions_in_app invoke_combine_transactions_in_miniprogram query_combine_order close_combine_order
      invoke_transactions_in_native invoke_transactions_in_js invoke_transactions_in_app invoke_transactions_in_h5 invoke_transactions_in_miniprogram query_order close_order
      request_profitsharing query_profitsharing return_profitsharing query_return_profitsharing finish_profitsharing query_profitsharing_amount add_profitsharing_receivers delete_profitsharing_receivers
      invoke_refund query_refund return_advance_refund query_return_advance_refund
      request_subsidies return_subsidies cancel_subsidies
      withdraw query_withdraw platform_withdraw query_platform_withdraw download_exception_withdraw_file
      media_video_upload media_upload
    ].each do |method_name|
      define_singleton_method(method_name) do |*args|
        WechatPay.ecommerce.send(method_name, *args)
      end
    end
  end
end

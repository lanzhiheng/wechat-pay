# frozen_string_literal: true

module WechatPay
  module Ecommerce
    class << self
      INVOKE_TRANSACTIONS_IN_JS_FIELDS = %i[sub_mchid description out_trade_no notify_url amount].freeze # :nodoc:
      #
      # js下单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_2.shtml
      #
      # Example:
      #
      # ```
      # params = {
      #   description: 'pay',
      #   out_trade_no: 'Order Number',
      #   payer: {
      #     sp_openid: 'wechat open id'
      #   },
      #   amount: {
      #     total: 10
      #   },
      #   sub_mchid: 'Your sub mchid',
      #   notify_url: 'the url'
      # }
      #
      # WechatPay::Ecommerce.invoke_transactions_in_app(params)
      # ```
      def invoke_transactions_in_js(params)
        transactions_method_by_suffix('jsapi', params)
      end

      INVOKE_TRANSACTIONS_IN_MINIPROGRAM_FIELDS = %i[sub_mchid description out_trade_no notify_url amount].freeze # :nodoc:
      #
      # 小程序下单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_3.shtml
      #
      # Example:
      #
      # ```
      # params = {
      #   description: 'pay',
      #   out_trade_no: 'Order Number',
      #   payer: {
      #     sp_openid: 'wechat open id'
      #   },
      #   amount: {
      #     total: 10
      #   },
      #   sub_mchid: 'Your sub mchid',
      #   notify_url: 'the url'
      # }
      #
      # WechatPay::Ecommerce.invoke_transactions_in_miniprogram(params)
      # ```
      def invoke_transactions_in_miniprogram(params)
        transactions_method_by_suffix('jsapi', params)
      end

      INVOKE_TRANSACTIONS_IN_APP_FIELDS = %i[sub_mchid description out_trade_no notify_url amount].freeze # :nodoc:
      #
      # App下单
      #
      # https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_1.shtml
      #
      # Example:
      #
      # ```
      # params = {
      #   description: 'pay',
      #   out_trade_no: 'Order Number',
      #   payer: {
      #     sp_openid: 'wechat open id'
      #   },
      #   amount: {
      #     total: 10
      #   },
      #   sub_mchid: 'Your sub mchid',
      #   notify_url: 'the url'
      # }
      #
      # WechatPay::Ecommerce.invoke_transactions_in_miniprogram(params)
      # ```
      def invoke_transactions_in_app(params)
        transactions_method_by_suffix('app', params)
      end

      INVOKE_TRANSACTIONS_IN_H5_FIELDS = %i[sub_mchid description out_trade_no notify_url amount].freeze # :nodoc:
      #
      # h5下单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_4.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
      #   description: 'pay',
      #   out_trade_no: 'Order Number',
      #   payer: {
      #     sp_openid: 'wechat open id'
      #   },
      #   amount: {
      #     total: 10
      #   },
      #   sub_mchid: 'Your sub mchid',
      #   notify_url: 'the url'
      # }
      #
      # WechatPay::Ecommerce.invoke_transactions_in_h5(params)
      # ```
      def invoke_transactions_in_h5(params)
        transactions_method_by_suffix('h5', params)
      end

      QUERY_ORDER_FIELDS = %i[sub_mchid out_trade_no transaction_id].freeze # :nodoc:
      #
      # 订单查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_5.shtml
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_order(sub_mchid: '16000008', transaction_id: '4323400972202104305133344444') # by transaction_id
      # WechatPay::Ecommerce.query_order(sub_mchid: '16000008', out_trade_no: 'N202104302474') # by out_trade_no
      # ```
      #
      def query_order(params)
        if params[:transaction_id]
          params.delete(:out_trade_no)
          transaction_id = params.delete(:transaction_id)
          path = "/v3/pay/partner/transactions/id/#{transaction_id}"
        else
          params.delete(:transaction_id)
          out_trade_no = params.delete(:out_trade_no)
          path = "/v3/pay/partner/transactions/out-trade-no/#{out_trade_no}"
        end

        params = params.merge({
                                sp_mchid: WechatPay.mch_id
                              })

        method = 'GET'
        query = build_query(params)
        url = "#{path}?#{query}"

        make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      CLOSE_ORDER_FIELDS = %i[sub_mchid out_trade_no].freeze # :nodoc:
      #
      # 关闭订单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_6.shtml
      #
      # ``` ruby
      # WechatPay::Ecommerce.close_order(sub_mchid: '16000008', out_trade_no: 'N3344445')
      # ```
      #
      def close_order(params)
        out_trade_no = params.delete(:out_trade_no)
        url = "/v3/pay/partner/transactions/out-trade-no/#{out_trade_no}/close"
        params = params.merge({
                                sp_mchid: WechatPay.mch_id
                              })

        method = 'POST'

        make_request(
          method: method,
          path: url,
          for_sign: params.to_json,
          payload: params.to_json
        )
      end

      private

      def transactions_method_by_suffix(suffix, params)
        url = "/v3/pay/partner/transactions/#{suffix}"
        method = 'POST'

        params = params.merge({
                                sp_appid: WechatPay.app_id,
                                sp_mchid: WechatPay.mch_id
                              })

        payload_json = params.to_json

        make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json
        )
      end
    end
  end
end

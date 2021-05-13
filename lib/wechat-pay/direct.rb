require 'json'
require 'wechat-pay/helper'

module WechatPay
  module Direct
    include WechatPayHelper

    class<<self
      INVOKE_TRANSACTIONS_IN_JS_FIELDS = %i[description out_trade out_trade_no payer amount notify_url].freeze # :nodoc:
      #
      # 直连js下单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
      #   appid: 'Your Open id',
      #   mchid: 'Your Mch id'',
      #   description: '回流',
      #   out_trade_no: 'Checking',
      #   payer: {
      #     openid: 'oly6s5c'
      #   },
      #   amount: {
      #     total: 1
      #   },
      #   notify_url: ENV['NOTIFICATION_URL']
      # }
      #
      # WechatPay::Direct.invoke_transactions_in_js(params)
      # ```
      def invoke_transactions_in_js(params)
        direct_transactions_method_by_suffix('jsapi', params)
      end

      INVOKE_TRANSACTIONS_IN_MINIPROGRAM_FIELDS = %i[description out_trade out_trade_no payer amount notify_url].freeze # :nodoc:
      #
      # 直连小程序下单
      #
      # Document:https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
      #   appid: 'Your Open id',
      #   mchid: 'Your Mch id'',
      #   description: '回流',
      #   out_trade_no: 'Checking',
      #   payer: {
      #     openid: 'oly6s5c'
      #   },
      #   amount: {
      #     total: 1
      #   },
      #   notify_url: ENV['NOTIFICATION_URL']
      # }
      #
      # WechatPay::Direct.invoke_transactions_in_miniprogram(params)
      # ```
      def invoke_transactions_in_miniprogram(params)
        direct_transactions_method_by_suffix('jsapi', params)
      end

      INVOKE_TRANSACTIONS_IN_APP_FIELDS = %i[description out_trade out_trade_no payer amount notify_url].freeze # :nodoc:
      #
      # 直连APP下单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_2_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
      #   appid: 'Your Open id',
      #   mchid: 'Your Mch id'',
      #   description: '回流',
      #   out_trade_no: 'Checking',
      #   payer: {
      #     openid: 'oly6s5c'
      #   },
      #   amount: {
      #     total: 1
      #   },
      #   notify_url: ENV['NOTIFICATION_URL']
      # }
      #
      # WechatPay::Direct.invoke_transactions_in_app(params)
      # ```
      def invoke_transactions_in_app(params)
        direct_transactions_method_by_suffix('app', params)
      end

      INVOKE_TRANSACTIONS_IN_H5_FIELDS = %i[description out_trade out_trade_no payer amount notify_url].freeze # :nodoc:
      #
      # 直连h5下单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_3_1.shtml
      #
      # Example:
      #
      # ```
      # params = {
      #   appid: 'Your Open id',
      #   mchid: 'Your Mch id'',
      #   description: '回流',
      #   out_trade_no: 'Checking',
      #   payer: {
      #     openid: 'oly6s5c'
      #   },
      #   amount: {
      #     total: 1
      #   },
      #   notify_url: ENV['NOTIFICATION_URL']
      # }
      #
      # WechatPay::Direct.invoke_transactions_in_h5(params)
      # ```
      def invoke_transactions_in_h5(params)
        direct_transactions_method_by_suffix('h5', params)
      end

      INVOKE_TRANSACTIONS_IN_NATIVE_FIELDS = %i[description out_trade out_trade_no payer amount notify_url].freeze # :nodoc:
      #
      # 直连native下单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_4_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
      #   appid: 'Your Open id',
      #   mchid: 'Your Mch id'',
      #   description: '回流',
      #   out_trade_no: 'Checking',
      #   payer: {
      #     openid: 'oly6s5c'
      #   },
      #   amount: {
      #     total: 1
      #   },
      #   notify_url: ENV['NOTIFICATION_URL']
      # }
      #
      # WechatPay::Direct.invoke_transactions_in_native(params)
      # ```
      def invoke_transactions_in_native(params)
        direct_transactions_method_by_suffix('native', params)
      end

      QUERY_ORDER_FIELDS = %i[out_trade_no transaction_id].freeze # :nodoc:
      #
      # 直连订单查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_2.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Direct.query_order(transaction_id: '4323400972202104305133344444') # by transaction_id
      # WechatPay::Direct.query_order(out_trade_no: 'N202104302474') # by out_trade_no
      # ```
      #
      def query_order(params)
        if params[:transaction_id]
          params.delete(:out_trade_no)
          transaction_id = params.delete(:transaction_id)
          path = "/v3/pay/transactions/id/#{transaction_id}"
        else
          params.delete(:transaction_id)
          out_trade_no = params.delete(:out_trade_no)
          path = "/v3/pay/transactions/out-trade-no/#{out_trade_no}"
        end

        params = params.merge({
                                mchid: WechatPay.mch_id
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

      CLOSE_ORDER_FIELDS = %i[out_trade_no].freeze # :nodoc:
      #
      # 关闭订单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_3.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Direct.close_order(out_trade_no: 'N3344445')
      # ```
      #
      def close_order(params)
        out_trade_no = params.delete(:out_trade_no)
        url = "/v3/pay/transactions/out-trade-no/#{out_trade_no}/close"
        params = params.merge({
                                mchid: WechatPay.mch_id
                              })

        method = 'POST'

        make_request(
          method: method,
          path: url,
          for_sign: params.to_json,
          payload: params.to_json
        )
      end

      INVOKE_REFUND_FIELDS = %i[transaction_id out_trade_no out_refund_no amount].freeze # :nodoc:
      #
      # 退款申请
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_9.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Direct.invoke_refund(transaction_id: '4323400972202104305131070170', total: 1, refund: 1, out_refund_no: 'R10000')
      # WechatPay::Direct.invoke_refund(out_trade_no: 'N2021', total: 1, refund: 1, out_refund_no: 'R10000').body
      # ```
      def invoke_refund(params)
        url = '/v3/refund/domestic/refunds'
        method = 'POST'
        amount = {
          refund: params.delete(:refund),
          total: params.delete(:total),
          currency: 'CNY'
        }

        params = params.merge({
                                amount: amount
                              })

        make_request(
          path: url,
          method: method,
          for_sign: params.to_json,
          payload: params.to_json
        )
      end

      QUERY_REFUND_FIELDS = %i[sub_mchid refund_id out_refund_no].freeze # :nodoc:
      #
      # 直连退款查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_10.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Direct.query_refund(out_refund_no: 'R10000')
      # ```
      #
      def query_refund(params)
        out_refund_no = params.delete(:out_refund_no)
        url = "/v3/refund/domestic/refunds/#{out_refund_no}"

        method = 'GET'

        make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      TRADEBILL_FIELDS = [:bill_date].freeze # :nodoc:
      #
      # 直连申请交易账单
      #
      # Todo: 跟商户平台接口相同
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_6.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::direct.tradebill(bill_date: '2021-04-30')
      # ```
      def tradebill(params)
        path = '/v3/bill/tradebill'
        method = 'GET'

        query = build_query(params)
        url = "#{path}?#{query}"

        make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      FUNDFLOWBILL_FIELDS = [:bill_date].freeze # :nodoc:
      #
      # 申请资金账单
      #
      # Todo: 跟商户平台接口相同
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_7.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Direct.fundflowbill(bill_date: '2021-04-30')
      # ```
      #
      def fundflowbill(params)
        path = '/v3/bill/fundflowbill'
        method = 'GET'

        query = build_query(params)
        url = "#{path}?#{query}"

        make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      private

      def direct_transactions_method_by_suffix(suffix, params)
        url = "/v3/pay/transactions/#{suffix}"
        method = 'POST'

        params = params.merge({
                                mchid: WechatPay.mch_id,
                                appid: WechatPay.app_id
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

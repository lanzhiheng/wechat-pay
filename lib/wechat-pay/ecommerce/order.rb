module WechatPay
  module Ecommerce
    class << self
      # app下单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_1.shtml
      #
      # Example:
      # params = {
      #   sp_appid: 'Your appid',
      #   sp_mchid: 'Your mchid',
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
      #
      #
      # js或小程序下单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_2.shtml
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_3.shtml
      #
      # Example:
      # params = {
      #   sp_appid: 'Your appid',
      #   sp_mchid: 'Your mchid',
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
      # WechatPay::Ecommerce.invoke_transactions_in_js(params)
      # OR
      # WechatPay::Ecommerce.invoke_transactions_in_miniprogram(params)
      #
      #
      # h5下单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_4.shtml
      #
      # Example:
      # params = {
      #   sp_appid: 'Your appid',
      #   sp_mchid: 'Your mchid',
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
      {
        js: 'jsapi',
        app: 'app',
        h5: 'h5',
        miniprogram: 'jsapi'
      }.each do |key, value|
        const_set("INVOKE_TRANSACTIONS_IN_#{key.upcase}_FIELDS",
                  %i[sp_appid sp_mchid sub_mchid description out_trade_no notify_url amount])
        define_method("invoke_transactions_in_#{key}") do |params|
          url = "/v3/pay/partner/transactions/#{value}"
          method = 'POST'

          payload_json = params.to_json

          make_request(
            method: method,
            path: url,
            for_sign: payload_json,
            payload: payload_json
          )
        end
      end

      # 订单查询
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_5.shtml
      # 微信支付订单号查询
      # WechatPay::Ecommerce.query_order(sub_mchid: '16000008', transaction_id: '4323400972202104305133344444')
      # 商户订单号查询
      # WechatPay::Ecommerce.query_order(sub_mchid: '16000008', out_trade_no: 'N202104302474')
      QUERY_ORDER_FIELDS = %i[sub_mchid out_trade_no transaction_id].freeze
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

      # 关闭订单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_6.shtml
      # WechatPay::Ecommerce.close_order(sub_mchid: '16000008', out_trade_no: 'N3344445')
      CLOSE_ORDER_FIELDS = %i[sub_mchid out_trade_no].freeze
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
    end
  end
end

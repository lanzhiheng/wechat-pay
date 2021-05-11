module WechatPay
  module Ecommerce
    class<<self
      # app合单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_1.shtml
      #
      # Example:
      # params = {
      #   combine_appid: 'Your appid',
      #   combine_mchid: 'Your mchid',
      #   combine_out_trade_no: 'combine_out_trade_no',
      #   combine_payer_info: {
      #     openid: 'client open id'
      #   },
      #   sub_orders: [
      #     {
      #       mchid: 'mchid',
      #       sub_mchid: 'sub mchid',
      #       attach: 'attach',
      #       amount: {
      #         total_amount: 100,
      #         currency: 'CNY'
      #       },
      #       out_trade_no: 'out_trade_no',
      #       description: 'description'
      #     }
      #   ]
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_app(params)
      #
      #
      # js或小程序合单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_3.shtml
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_4.shtml
      #
      # Example:
      # params = {
      #   combine_appid: 'Your appid',
      #   combine_mchid: 'Your mchid',
      #   combine_out_trade_no: 'combine_out_trade_no',
      #   combine_payer_info: {
      #     openid: 'client open id'
      #   },
      #   sub_orders: [
      #     {
      #       mchid: 'mchid',
      #       sub_mchid: 'sub mchid',
      #       attach: 'attach',
      #       amount: {
      #         total_amount: 100,
      #         currency: 'CNY'
      #       },
      #       out_trade_no: 'out_trade_no',
      #       description: 'description'
      #     }
      #   ]
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_js(params)
      # Or
      # WechatPay::Ecommerce.invoke_combine_transactions_in_miniprogram(params)
      #
      # h5合单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_2.shtml
      #
      # Example:
      # params = {
      #   combine_appid: 'Your appid',
      #   combine_mchid: 'Your mchid',
      #   combine_out_trade_no: 'combine_out_trade_no',
      #   sub_orders: [
      #     {
      #       mchid: 'mchid',
      #       sub_mchid: 'sub mchid',
      #       attach: 'attach',
      #       amount: {
      #         total_amount: 100,
      #         currency: 'CNY'
      #       },
      #       out_trade_no: 'out_trade_no',
      #       description: 'description'
      #     }
      #   ]
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_h5(params)
      #
      # native合单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_5.shtml
      #
      # Example:
      # params = {
      #   combine_appid: 'Your appid',
      #   combine_mchid: 'Your mchid',
      #   combine_out_trade_no: 'combine_out_trade_no',
      #   sub_orders: [
      #     {
      #       mchid: 'mchid',
      #       sub_mchid: 'sub mchid',
      #       attach: 'attach',
      #       amount: {
      #         total_amount: 100,
      #         currency: 'CNY'
      #       },
      #       out_trade_no: 'out_trade_no',
      #       description: 'description'
      #     }
      #   ]
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_native(params)
      {
        js: 'jsapi',
        app: 'app',
        h5: 'h5',
        native: 'native',
        miniprogram: 'jsapi'
      }.each do |key, value|
        const_set("INVOKE_COMBINE_TRANSACTIONS_IN_#{key.upcase}_FIELDS",
                  %i[combine_appid combine_mchid combine_out_trade_no combine_payer_info sub_orders notify_url])
        define_method("invoke_combine_transactions_in_#{key}") do |params|
          url = "/v3/combine-transactions/#{value}"
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

      # 合单查询
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_11.shtml
      # 商户合单号查询
      # WechatPay::Ecommerce.query_order(combine_out_trade_no: 'C202104302474')
      QUERY_COMBINE_ORDER_FIELDS = %i[combine_out_trade_no].freeze
      def query_combine_order(params)
        combine_out_trade_no = params.delete(:combine_out_trade_no)

        url = "/v3/combine-transactions/out-trade-no/#{combine_out_trade_no}"

        method = 'GET'

        make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      # 关闭合单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_11.shtml
      # WechatPay::Ecommerce.close_combine_order(combine_out_trade_no: 'C202104302474')
      CLOSE_COMBINE_ORDER_FIELDS = %i[combine_out_trade_no sub_orders].freeze
      def close_combine_order(params)
        combine_out_trade_no = params.delete(:combine_out_trade_no)

        url = "/v3/combine-transactions/out-trade-no/#{combine_out_trade_no}/close"

        payload = {
          combine_appid: WechatPay.appid
        }.merge(params)

        payload_json = payload.to_json

        method = 'POST'

        make_request(
          method: method,
          for_sign: payload_json,
          payload: payload_json,
          path: url
        )
      end
    end
  end
end

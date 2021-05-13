# frozen_string_literal: true

module WechatPay
  module Ecommerce
    class<<self
      INVOKE_COMBINE_TRANSACTIONS_IN_NATIVE_FIELDS = %i[combine_out_trade_no combine_payer_info sub_orders notify_url].freeze # :nodoc:
      #
      # native合单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_5.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
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
      #   ],
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_native(params)
      # ```
      def invoke_combine_transactions_in_native(params)
        combine_transactions_method_by_suffix('native', params)
      end

      INVOKE_COMBINE_TRANSACTIONS_IN_H5_FIELDS = %i[combine_out_trade_no combine_payer_info sub_orders notify_url].freeze # :nodoc:
      #
      # h5合单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_2.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
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
      #   ],
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_h5(params)
      # ```
      def invoke_combine_transactions_in_h5(params)
        combine_transactions_method_by_suffix('h5', params)
      end

      INVOKE_COMBINE_TRANSACTIONS_IN_APP_FIELDS = %i[combine_out_trade_no combine_payer_info sub_orders notify_url].freeze # :nodoc:
      #
      # app合单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
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
      #   ],
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_app(params)
      # ```
      def invoke_combine_transactions_in_app(params)
        combine_transactions_method_by_suffix('app', params)
      end

      INVOKE_COMBINE_TRANSACTIONS_IN_JS_FIELDS = %i[combine_out_trade_no combine_payer_info sub_orders notify_url].freeze # :nodoc:
      #
      # js合单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_3.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
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
      #   ],
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_js(params)
      # ```
      def invoke_combine_transactions_in_js(params)
        combine_transactions_method_by_suffix('jsapi', params)
      end

      INVOKE_COMBINE_TRANSACTIONS_IN_MINIPROGRAM_FIELDS = %i[combine_out_trade_no combine_payer_info sub_orders notify_url].freeze # :nodoc:
      #
      # 小程序合单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_4.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
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
      #   ],
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_miniprogram(params)
      # ```
      def invoke_combine_transactions_in_miniprogram(params)
        combine_transactions_method_by_suffix('jsapi', params)
      end

      QUERY_COMBINE_ORDER_FIELDS = %i[combine_out_trade_no].freeze # :nodoc:
      #
      # 合单查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_11.shtml
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_order(combine_out_trade_no: 'C202104302474')
      # ```
      #
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

      CLOSE_COMBINE_ORDER_FIELDS = %i[combine_out_trade_no sub_orders].freeze # :nodoc:
      #
      # 关闭合单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_11.shtml
      #
      # ``` ruby
      # WechatPay::Ecommerce.close_combine_order(combine_out_trade_no: 'C202104302474')
      # ```
      def close_combine_order(params)
        combine_out_trade_no = params.delete(:combine_out_trade_no)

        url = "/v3/combine-transactions/out-trade-no/#{combine_out_trade_no}/close"

        payload = {
          combine_appid: WechatPay.app_id
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

      private

      def combine_transactions_method_by_suffix(suffix, params)
        url = "/v3/combine-transactions/#{suffix}"
        method = 'POST'

        params = params.merge({
                                combine_mchid: WechatPay.mch_id,
                                combine_appid: WechatPay.app_id
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

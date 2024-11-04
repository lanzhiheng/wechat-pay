# frozen_string_literal: true

module WechatPay
  module Ecommerce
    # 补差相关
    module Subsidies
      REQUEST_SUBSIDIES_FIELDS = %i[sub_mchid transaction_id amount description].freeze # :nodoc:
      #
      # 请求补差
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_5_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.request_subsidies(sub_mchid: '16000000', transaction_id: '4323400972202104305131070170', amount: 1, description: '订单补差')
      # ```
      #
      def request_subsidies(params)
        url = '/v3/ecommerce/subsidies/create'
        method = 'POST'

        payload_json = params.to_json

        @client.make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json
        )
      end

      RETURN_SUBSIDIES_FIELDS = %i[sub_mchid transaction_id amount description out_order_no].freeze # :nodoc:
      #
      # 补差回退
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_5_2.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.return_subsidies(sub_mchid: '16000000', transaction_id: '4323400972202104305131070170', amount: 1, description: '订单补差', out_order_no: 'P103333')
      # ```

      def return_subsidies(params)
        url = '/v3/ecommerce/subsidies/return'
        method = 'POST'

        payload_json = params.to_json

        @client.make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json
        )
      end

      CANCEL_SUBSIDIES_FIELDS = %i[sub_mchid transaction_id description].freeze # :nodoc:
      #
      # 取消补差
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_5_3.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.return_subsidies(sub_mchid: '1600000', transaction_id: '4323400972202104305131070170', amount: 1, description: '订单补差', out_order_no: 'P103333')
      # ```
      #
      def cancel_subsidies(params)
        url = '/v3/ecommerce/subsidies/cancel'
        method = 'POST'

        payload_json = params.to_json

        @client.make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json
        )
      end
    end
  end
end

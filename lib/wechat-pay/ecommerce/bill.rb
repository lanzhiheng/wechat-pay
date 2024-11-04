# frozen_string_literal: true

module WechatPay
  module Ecommerce
    # 账单相关
    module Bill
      TRADEBILL_FIELDS = [:bill_date].freeze # :nodoc:
      #
      # 申请交易账单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_9_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.tradebill(bill_date: '2021-04-30')
      # ```
      def tradebill(params)
        path = '/v3/bill/tradebill'
        method = 'GET'

        query = @client.build_query(params)
        url = "#{path}?#{query}"

        @client.make_request(
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
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_9_2.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.fundflowbill(bill_date: '2021-04-30')
      # ```
      #
      def fundflowbill(params)
        path = '/v3/bill/fundflowbill'
        method = 'GET'

        query = @client.build_query(params)
        url = "#{path}?#{query}"

        @client.make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      ECOMMERCE_FUNDFLOWBILL_FIELDS = %i[bill_date account_type algorithm].freeze # :nodoc:
      #
      # 二级商户资金账单
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_9_5.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.ecommerce_fundflowbill(bill_date: '2021-04-30', account_type: 'ALL', algorithm: 'AEAD_AES_256_GCM')
      # ```
      #
      def ecommerce_fundflowbill(params)
        path = '/v3/ecommerce/bill/fundflowbill'
        method = 'GET'

        query = @client.build_query(params)
        url = "#{path}?#{query}"

        @client.make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end
    end
  end
end

module WechatPay
  module Ecommerce
    class<<self
      # 申请交易账单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_9_1.shtml
      # > WechatPay::Ecommerce.tradebill(bill_date: '2021-04-30')
      TRADEBILL_FIELDS = [:bill_date].freeze
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

      # 申请资金账单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_9_2.shtml
      # > WechatPay::Ecommerce.fundflowbill(bill_date: '2021-04-30')
      FUNDFLOWBILL_FIELDS = [:bill_date].freeze
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

      # 二级商户资金账单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_9_5.shtml
      # > WechatPay::Ecommerce.ecommerce_fundflowbill(bill_date: '2021-04-30', account_type: 'ALL', algorithm: 'AEAD_AES_256_GCM')
      ECOMMERCE_FUNDFLOWBILL_FIELDS = [:bill_date, :account_type, :algorithm].freeze
      def ecommerce_fundflowbill(params)
        path = '/v3/ecommerce/bill/fundflowbill'
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
    end
  end
end

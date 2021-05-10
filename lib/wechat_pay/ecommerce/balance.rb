module WechatPay
  module Ecommerce
    class<<self
      # 余额实时查询
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_7_1.shtml
      # WechatPay::Ecommerce.query_realtime_balance(sub_mchid: '1600000')
      QUERY_REALTIME_BALANCE_FIELDS = [:sub_mchid].freeze
      def query_realtime_balance(params)
        sub_mchid = params.delete(:sub_mchid)
        url = "/v3/ecommerce/fund/balance/#{sub_mchid}"
        method = 'GET'

        make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      # 日终余额查询
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_7_2.shtml
      # WechatPay::Ecommerce.query_endday_balance(sub_mchid: '1600000', date: '2019-08-17')
      QUERY_ENDDAY_BALANCE_FIELDS = [:sub_mchid, :date].freeze
      def query_endday_balance(params)
        sub_mchid = params.delete(:sub_mchid)
        path = "/v3/ecommerce/fund/balance/#{sub_mchid}"
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

      # 平台商户实时余额
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_7_3.shtml
      # Example:
      # WechatPay::Ecommerce.query_platform_realtime_balance(account_type: 'BASIC')
      # WechatPay::Ecommerce.query_platform_realtime_balance(account_type: 'FEES')
      QUERY_PLATFORM_REALTIME_BALANCE_FIELDS = %i[account_type].freeze
      def query_platform_realtime_balance(params)
        account_type = params.delete(:account_type)
        url = "/v3/merchant/fund/balance/#{account_type}"
        method = 'GET'

        make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      # 平台商户日终余额
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_7_4.shtml
      # Example:
      # WechatPay::Ecommerce.query_platform_endday_balance(account_type: 'BASIC')
      # WechatPay::Ecommerce.query_platform_endday_balance(account_type: 'FEES')
      QUERY_PLATFORM_ENDDAY_BALANCE_FIELDS = %i[account_type date].freeze
      def query_platform_endday_balance(params)
        account_type = params.delete(:account_type)
        path = "/v3/merchant/fund/dayendbalance/#{account_type}"
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

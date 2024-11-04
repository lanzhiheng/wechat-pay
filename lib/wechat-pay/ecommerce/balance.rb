# frozen_string_literal: true

module WechatPay
  module Ecommerce
    # 余额相关
    module Balance
      QUERY_REALTIME_BALANCE_FIELDS = [:sub_mchid].freeze # :nodoc:
      #
      # 余额实时查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_7_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_realtime_balance(sub_mchid: '1600000')
      # ```
      def query_realtime_balance(params)
        sub_mchid = params.delete(:sub_mchid)
        url = "/v3/ecommerce/fund/balance/#{sub_mchid}"
        method = 'GET'

        @client.make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      QUERY_ENDDAY_BALANCE_FIELDS = %i[sub_mchid date].freeze # :nodoc:
      #
      # 日终余额查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_7_2.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_endday_balance(sub_mchid: '1600000', date: '2019-08-17')
      # ```
      def query_endday_balance(params)
        sub_mchid = params.delete(:sub_mchid)
        path = "/v3/ecommerce/fund/balance/#{sub_mchid}"
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

      QUERY_PLATFORM_REALTIME_BALANCE_FIELDS = %i[account_type].freeze # :nodoc:
      #
      # 平台商户实时余额
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_7_3.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_platform_realtime_balance(account_type: 'BASIC') # basic account
      # WechatPay::Ecommerce.query_platform_realtime_balance(account_type: 'FEES') # fees account
      # ```
      #
      def query_platform_realtime_balance(params)
        account_type = params.delete(:account_type)
        url = "/v3/merchant/fund/balance/#{account_type}"
        method = 'GET'

        @client.make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      QUERY_PLATFORM_ENDDAY_BALANCE_FIELDS = %i[account_type date].freeze # :nodoc:
      #
      # 平台商户日终余额
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_7_4.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_platform_endday_balance(account_type: 'BASIC')
      # WechatPay::Ecommerce.query_platform_endday_balance(account_type: 'FEES')
      # ```
      #
      def query_platform_endday_balance(params)
        account_type = params.delete(:account_type)
        path = "/v3/merchant/fund/dayendbalance/#{account_type}"
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

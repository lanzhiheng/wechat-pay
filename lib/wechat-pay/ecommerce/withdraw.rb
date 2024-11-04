# frozen_string_literal: true

module WechatPay
  module Ecommerce
    # 提现相关
    module Withdraw
      WITHDRAW_FIELDS = %i[sub_mchid out_request_no amount].freeze # :nodoc:
      #
      # 二级商户提现
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_8_2.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.withdraw(sub_mchid: '160000', out_request_no: 'P10000', amount: 1)
      # ```
      #
      def withdraw(params)
        url = '/v3/ecommerce/fund/withdraw'
        method = 'POST'

        @client.make_request(
          method: method,
          path: url,
          for_sign: params.to_json,
          payload: params.to_json
        )
      end

      QUERY_WITHDRAW_FIELDS = %i[withdraw_id out_request_no sub_mchid].freeze # :nodoc:
      #
      # 二级商户提现查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_8_3.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_withdraw(withdraw_id: '335556', sub_mchid: '160000')
      # WechatPay::Ecommerce.query_withdraw(out_request_no: 'P1000', sub_mchid: '160000')
      # ```
      #
      def query_withdraw(params)
        if params[:withdraw_id]
          params.delete(:out_request_no)
          withdraw_id = params.delete(:withdraw_id)
          path = "/v3/ecommerce/fund/withdraw/#{withdraw_id}"
        else
          params.delete(:withdraw_id)
          out_request_no = params.delete(:out_request_no)
          path = "/v3/ecommerce/fund/withdraw/out-request-no/#{out_request_no}"
        end

        method = 'GET'
        query = @client.build_query(params)
        url = "#{path}?#{query}"

        @client.make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      PLATFORM_WITHDRAW_FIELDS = %i[out_request_no amount account_type].freeze # :nodoc:
      #
      # 电商平台提现
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_8_5.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.platform_withdraw(out_request_no: 'P10000', amount: 1, account_type: 'BASIC')
      # WechatPay::Ecommerce.platform_withdraw(out_request_no: 'P10000', amount: 1, account_type: 'FEES')
      # ```
      #
      def platform_withdraw(params)
        url = '/v3/merchant/fund/withdraw'
        method = 'POST'

        @client.make_request(
          method: method,
          path: url,
          for_sign: params.to_json,
          payload: params.to_json
        )
      end

      QUERY_PLATFORM_WITHDRAW_FIELDS = %i[withdraw_id out_request_no].freeze # :nodoc:
      #
      # 商户平台提现查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_8_6.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_platform_withdraw(out_request_no: 'P1000')
      # WechatPay::Ecommerce.query_platform_withdraw(withdraw_id: '12313153')
      # ```
      #
      def query_platform_withdraw(params)
        if params[:withdraw_id]
          params.delete(:out_request_no)
          withdraw_id = params.delete(:withdraw_id)
          url = "/v3/merchant/fund/withdraw/withdraw-id/#{withdraw_id}"
        else
          params.delete(:withdraw_id)
          out_request_no = params.delete(:out_request_no)
          url = "/v3/merchant/fund/withdraw/out-request-no/#{out_request_no}"
        end

        method = 'GET'

        @client.make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      DOWNLOAD_EXCEPTION_WITHDRAW_FILE = %i[bill_type bill_date].freeze # :nodoc:
      #
      # 按日下载提现异常文件
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_8_4.shtml
      #
      # ``` ruby
      # WechatPay::Ecommerce.download_exception_withdraw_file(bill_type: 'NO_SUCC', bill_date: '2021-05-10')
      # ```
      def download_exception_withdraw_file(params)
        bill_type = params.delete(:bill_type)
        path = "/v3/merchant/fund/withdraw/bill-type/#{bill_type}"

        method = 'GET'

        query = @client.build_query(params)
        url = "#{path}?#{query}"

        @client.make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end
    end
  end
end

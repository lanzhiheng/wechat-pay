module WechatPay
  module Ecommerce
    class<<self
      # 二级商户提现
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_8_2.shtml
      # Example:
      # WechatPay::Ecommerce.withdraw(sub_mchid: '160000', out_request_no: 'P10000', amount: 1)
      WITHDRAW_FIELDS = %i[sub_mchid out_request_no amount].freeze
      def withdraw(params)
        url = '/v3/ecommerce/fund/withdraw'
        method = 'POST'

        make_request(
          method: method,
          path: url,
          for_sign: params.to_json,
          payload: params.to_json
        )
      end

      # 二级商户提现查询
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_8_3.shtml
      # Example:
      # WechatPay::Ecommerce.query_withdraw(withdraw_id: '335556', sub_mchid: '160000')
      # WechatPay::Ecommerce.query_withdraw(out_request_no: 'P1000', sub_mchid: '160000')
      QUERY_WITHDRAW_FIELDS = %i[withdraw_id out_request_no sub_mchid].freeze
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

      # 电商平台提现
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_8_5.shtml
      # Example:
      # WechatPay::Ecommerce.platform_withdraw(out_request_no: 'P10000', amount: 1, account_type: 'BASIC')
      # WechatPay::Ecommerce.platform_withdraw(out_request_no: 'P10000', amount: 1, account_type: 'FEES')
      PLATFORM_WITHDRAW_FIELDS = %i[out_request_no amount account_type].freeze
      def platform_withdraw(params)
        url = '/v3/merchant/fund/withdraw'
        method = 'POST'

        make_request(
          method: method,
          path: url,
          for_sign: params.to_json,
          payload: params.to_json
        )
      end

      # 商户平台提现查询
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_8_6.shtml
      # Example:
      # WechatPay::Ecommerce.query_platform_withdraw(out_request_no: 'P1000')
      # WechatPay::Ecommerce.query_platform_withdraw(withdraw_id: '12313153')
      QUERY_PLATFORM_WITHDRAW_FIELDS = %i[withdraw_id out_request_no].freeze
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

        make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      # 按日下载提现异常文件
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_8_4.shtml
      # WechatPay::Ecommerce.download_exception_withdraw_file(bill_type: 'NO_SUCC', bill_date: '2021-05-10')
      DOWNLOAD_EXCEPTION_WITHDRAW_FILE = %i[bill_type bill_date]
      def download_exception_withdraw_file(params)
        bill_type = params.delete(:bill_type)
        path = "/v3/merchant/fund/withdraw/bill-type/#{bill_type}"

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
    end
  end
end

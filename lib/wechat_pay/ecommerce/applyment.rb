module WechatPay
  module Ecommerce
    class << self
      # 二级商户进件
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter11_1_1.shtml
      # Example:
      # Nothing
      def applyment(payload)
        url = '/v3/ecommerce/applyments/'
        method = 'POST'

        payload_json = payload.to_json

        make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json,
          extra_headers: {
            'Wechatpay-Serial' => WechatPay.platform_serial_no
          }
        )
      end

      # 通过商户的申请单或微信的申请单号查询
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter11_1_2.shtml
      # Example:
      # WechatPay::Ecommerce.query_applyment(out_request_no: 'APPLYMENT_00000000005').body
      # WechatPay::Ecommerce.query_applyment(applyment_id: '200040444455566667').body
      QUERY_APPLYMENTS_FIELDS = %i[applyment_id out_request_no].freeze
      def query_applyment(params)
        if params[:applyment_id]
          applyment_id = params.delete(:applyment_id)
          url = "/v3/ecommerce/applyments/#{applyment_id}"
        else
          out_request_no = params.delete(:out_request_no)
          url = "/v3/ecommerce/applyments/out-request-no/#{out_request_no}"
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

      # 证书获取
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_1_3.shtml
      # Example:
      # WechatPay::Ecommerce.get_certificates
      def get_certificates
        url = '/v3/certificates'
        method = 'GET'

        make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      # 查询结算账户
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_1_5.shtml
      # Example:
      # WechatPay::Ecommerce.query_settlement(sub_mchid: '16000000')
      INVOKE_QUERY_SETTLEMENT_FIELDS = [:sub_mchid].freeze
      def query_settlement(params)
        sub_mchid = params.delete(:sub_mchid)
        url = "/v3/apply4sub/sub_merchants/#{sub_mchid}/settlement"
        method = 'GET'

        make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      # 修改结算账号
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_1_4.shtml
      # Example:
      # WechatPay::Ecommerce.modify_settlement(sub_mchid: '15000000', account_type: 'ACCOUNT_TYPE_PRIVATE', account_bank: '工商银行', bank_address_code: '110000', account_number: WechatPay::Sign.sign_important_info('755555555'))
      INVOKE_MODIFY_SETTLEMENT_FIELDS = %i[sub_mchid account_type account_bank bank_address_code account_number].freeze
      def modify_settlement(params)
        sub_mchid = params.delete(:sub_mchid)
        url = "/v3/apply4sub/sub_merchants/#{sub_mchid}/modify-settlement"
        method = 'POST'

        payload_json = params.to_json

        make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json,
          extra_headers: {
            'Wechatpay-Serial' => WechatPay.platform_serial_no
          }
        )
      end
    end
  end
end

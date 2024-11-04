# frozen_string_literal: true

module WechatPay
  module Ecommerce
    # 商户进件相关
    module Applyment
      # 二级商户进件
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter11_1_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {
      #   "organization_type": "2",
      #   "business_license_info": {
      #     "business_license_copy": "47ZC6GC-vnrbEg05InE4d2I6_H7I4",
      #     "business_license_number": "123456789012345678",
      #     "merchant_name": "腾讯科技有限公司",
      #     "legal_person": "张三"
      #   },
      #   "organization_cert_info": {
      #     "organization_copy": "47ZC6GC-vnrbEny__Ie_An5-tCpqxuGprrKhpVBDIUv0OF4wFNIO4kqg05InE4d2I6_H7I4 ",
      #     "organization_time": "[\"2014-01-01\",\"长期\"]",
      #     "organization_number": "12345679-A"
      #   },
      #   "id_card_info": {
      #     "id_card_copy": "jTpGmxUX3FBWVQ5NJTZvlKC-ehEuo0BJqRTvDujqhThn4ReFxikqJ5YW6zFQ",
      #     "id_card_national": "47ZC6GC-vnrbEny__Ie_AnGprrKhpVBDIUv0OF4wFNIO4kqg05InE4d2I6_H7I4",
      #     "id_card_name": "pVd1HJ6z7UtC + xriudjD5AqhZ9evAM + Jv1z0NVa8MRtelw / wDa4SzfeespQO / 0 kjiwfqdfg =",
      #     "id_card_number": "UZFETyabYFFlgvGh6R4vTzDRgzvA2HtP5VHahNhSUqhR9iuGTunRPRVFg ==",
      #     "id_card_valid_time": "2026-06-06"
      #   },
      #   "need_account_info": true,
      #   "account_info": {
      #     "bank_account_type": "74",
      #     "account_name": "fTA4TXc8yMOwFCYeGPktOOSbOBei3KAmUWHGxCQo2hfaC7xumTqXR7 / NyRHpFKXURQFcmmw ==",
      #     "account_bank": "工商银行",
      #     "bank_address_code": "110000",
      #     "bank_branch_id": "402713354941",
      #     "bank_name": "施秉县农村信用合作联社城关信用社",
      #     "account_number": "d+xT+MQCvrLHUVD5Fnx30mr4L8sPndjXTd75kPkyjqnoMRrEEaYQE8ZRGYoeorwC"
      #   },
      #   "contact_info": {
      #     "contact_type": "65",
      #     "contact_name": "pVd1HJ6zyvPedzGaV+Xy7UDa4SzfeespQO / 0 kjiwfqdfg ==",
      #     "contact_id_card_number": "UZFETyabYFFlgvGh6R4vTzDEOiZZ4ka9+5RgzvA2rJx+NztYUbN209rqR9iuGTunRPRVFg ==",
      #     "mobile_phone": "Uy5Hb0c5Se/orEbrWze/ROHu9EPAs/CigDlJ2fnyzC1ppJNBrqcBszhYQUlu5zn6o2uZpBhAsQwd3QAjw==",
      #     "contact_email": "Uy5Hb0c5Se/orEbrWze/ROHu9EPAs/CigDlJ2fnyzC1ppJNaLZExOEzmUn6o2uZpBhAsQwd3QAjw=="
      #   },
      #   "sales_scene_info": {
      #     "store_name": "爱烧烤",
      #     "store_url": "http://www.qq.com",
      #     "store_qr_code": "jTpGmxUX3FBWVQ5NJTZvlKX_gdU4cRz7z5NxpnFuAujqhThn4ReFxikqJ5YW6zFQ"
      #   },
      #   "merchant_shortname": "爱烧烤",
      #   "out_request_no": "APPLYMENT_00000000001",
      #   "qualifications": "[\"jTpGmxUX3FBWVQ5NJInE4d2I6_H7I4\"]",
      #   "business_addition_pics": "[\"jTpGmg05InE4d2I6_H7I4\"]",
      #   "business_addition_desc": "特殊情况，说明原因"
      # }
      # ```
      #
      # ``` ruby
      # WechatPay::Ecommerce.applyment(params)
      # ```
      #
      def applyment(payload)
        url = '/v3/ecommerce/applyments/'
        method = 'POST'

        payload_json = payload.to_json

        @client.make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json,
          extra_headers: {
            'Wechatpay-Serial' => @config.platform_serial_no
          }
        )
      end

      QUERY_APPLYMENT_FIELDS = %i[applyment_id out_request_no].freeze # :nodoc:
      #
      # 通过商户的申请单或微信的申请单号查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter11_1_2.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_applyment(out_request_no: 'APPLYMENT_00000000005') # by out_request_no
      # WechatPay::Ecommerce.query_applyment(applyment_id: '200040444455566667') # by_applyment_id
      # ```
      #
      def query_applyment(params)
        if params[:applyment_id]
          applyment_id = params.delete(:applyment_id)
          url = "/v3/ecommerce/applyments/#{applyment_id}"
        else
          out_request_no = params.delete(:out_request_no)
          url = "/v3/ecommerce/applyments/out-request-no/#{out_request_no}"
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

      # 证书获取
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_1_3.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.certificates
      # ```
      #
      def certificates
        url = '/v3/certificates'
        method = 'GET'

        @client.make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      INVOKE_QUERY_SETTLEMENT_FIELDS = [:sub_mchid].freeze # :nodoc:
      #
      # 查询结算账户
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_1_5.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_settlement(sub_mchid: '16000000')
      # ```
      #
      def query_settlement(params)
        sub_mchid = params.delete(:sub_mchid)
        url = "/v3/apply4sub/sub_merchants/#{sub_mchid}/settlement"
        method = 'GET'

        @client.make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      INVOKE_MODIFY_SETTLEMENT_FIELDS = %i[sub_mchid account_type account_bank bank_address_code account_number].freeze # :nodoc:
      #
      # 修改结算账号
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_1_4.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.modify_settlement(sub_mchid: '15000000', account_type: 'ACCOUNT_TYPE_PRIVATE', account_bank: '工商银行', bank_address_code: '110000', account_number: WechatPay::Sign.sign_important_info('755555555'))
      # ```
      #
      def modify_settlement(params)
        sub_mchid = params.delete(:sub_mchid)
        url = "/v3/apply4sub/sub_merchants/#{sub_mchid}/modify-settlement"
        method = 'POST'

        payload_json = params.to_json

        @client.make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json,
          extra_headers: {
            'Wechatpay-Serial' => @config.platform_serial_no
          }
        )
      end
    end
  end
end

# frozen_string_literal: true

module WechatPay
  # 退款相关
  module Ecommerce
    INVOKE_REFUND_FIELDS = %i[sub_mchid out_trade_no total refund out_refund_no].freeze # :nodoc:
    #
    # 退款申请
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_6_1.shtml
    #
    # Example:
    #
    # ``` ruby
    # WechatPay::Ecommerce.invoke_refund(sub_mchid: '1600000', transaction_id: '4323400972202104305131070170', total: 1, refund: 1, description: '退款', out_refund_no: 'R10000') # by transaction_id
    # WechatPay::Ecommerce.invoke_refund(sub_mchid: '1608977559', total: 1, refund: 1, description: '退款', out_trade_no: 'N202104302474', out_refund_no: 'R10000') # by out_trade_no
    # ```
    def self.invoke_refund(params)
      url = '/v3/ecommerce/refunds/apply'
      method = 'POST'
      amount = {
        refund: params.delete(:refund),
        total: params.delete(:total),
        currency: 'CNY'
      }

      params = {
        amount: amount,
        sp_appid: WechatPay.app_id
      }.merge(params)

      make_request(
        path: url,
        method: method,
        for_sign: params.to_json,
        payload: params.to_json
      )
    end

    QUERY_REFUND_FIELDS = %i[sub_mchid refund_id out_refund_no].freeze # :nodoc:
    #
    # 退款查询
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_6_2.shtml
    #
    # Example:
    #
    # ``` ruby
    # WechatPay::Ecommerce.query_refund(sub_mchid: '16000000', out_refund_no: 'N202104302474') # 注意这里的out_refund_no用的是商户订单号，微信文档有误
    # WechatPay::Ecommerce.query_refund(sub_mchid: '16000000', refund_id: '420000103020210508005624628') # 注意这里的refund_id用的是微信交易单号transaction_id，微信文档有误
    # ```
    #
    def self.query_refund(params)
      if params[:refund_id]
        params.delete(:out_refund_no)
        refund_id = params.delete(:refund_id)
        path = "/v3/pay/partner/transactions/id/#{refund_id}"
      else
        params.delete(:refund_id)
        out_refund_no = params.delete(:out_refund_no)
        path = "/v3/pay/partner/transactions/out-trade-no/#{out_refund_no}"
      end

      params = params.merge({
                              sp_mchid: WechatPay.mch_id
                            })

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

    RETURN_ADVANCE_REFUND_FIELDS = %i[refund_id sub_mchid].freeze # :nodoc:
    #
    # 垫付退款回补
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_6_4.shtml
    #
    # Example:
    #
    # ``` ruby
    # WechatPay::Ecommerce.return_advance_refund(refund_id: '50300908092021043008398036516', sub_mchid: '160000')
    # ```
    #
    def self.return_advance_refund(params)
      refund_id = params.delete(:refund_id)
      url = "/v3/ecommerce/refunds/#{refund_id}/return-advance"
      method = 'POST'

      make_request(
        path: url,
        method: method,
        for_sign: params.to_json,
        payload: params.to_json
      )
    end

    QUERY_RETURN_ADVANCE_REFUND_FIELDS = %i[sub_mchid refund_id].freeze # :nodoc:
    #
    # 退款查询
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_6_2.shtml
    #
    # Example:
    #
    # ``` ruby
    # WechatPay::Ecommerce.query_refund(sub_mchid: '16000000', out_refund_no: 'N202104302474') # 注意这里的out_refund_no用的是商户订单号，微信文档有误
    # WechatPay::Ecommerce.query_refund(sub_mchid: '16000000', refund_id: '420000103020210508005624628') # 注意这里的refund_id用的是微信交易单号transaction_id，微信文档有误
    # ```
    #
    def self.query_return_advance_refund(params)
      refund_id = params.delete(:refund_id)
      path = "/v3/ecommerce/refunds/#{refund_id}/return-advance"
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

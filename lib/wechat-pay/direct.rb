# frozen_string_literal: true

require 'json'
require 'wechat-pay/helper'

module WechatPay
  # # 直连商户相关接口封装（常用的已有，待完善）
  # 文档: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_1.shtml
  module Direct
    include WechatPayHelper

    # @private
    # @!macro [attach] define_transaction_method
    #   直连$1下单
    #
    #   Document: $3
    #
    #   Example:
    #
    #   ``` ruby
    #   params = {
    #     appid: 'Your Open id',
    #     mchid: 'Your Mch id'',
    #     description: '回流',
    #     out_trade_no: 'Checking',
    #     payer: {
    #       openid: 'oly6s5c'
    #     },
    #     amount: {
    #       total: 1
    #     },
    #     notify_url: ENV['NOTIFICATION_URL']
    #   }
    #
    #   WechatPay::Direct.invoke_transactions_in_$1(params)
    #   ```
    #   @!method invoke_transactions_in_$1
    #   @!scope class
    def self.define_transaction_method(key, value, _document)
      const_set("INVOKE_TRANSACTIONS_IN_#{key.upcase}_FIELDS",
                %i[description out_trade out_trade_no payer amount notify_url].freeze)
      define_singleton_method "invoke_transactions_in_#{key}" do |params|
        direct_transactions_method_by_suffix(value, params)
      end
    end

    define_transaction_method('js', 'jsapi', 'https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_1.shtml')
    define_transaction_method('miniprogram', 'jsapi', 'https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_1.shtml')
    define_transaction_method('app', 'app', 'https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_2_1.shtml')
    define_transaction_method('h5', 'h5', 'https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_3_1.shtml')
    define_transaction_method('native', 'native', 'https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_4_1.shtml')

    # @private
    # @!macro [attach] define_combine_transaction_method
    #   直连合单$1下单
    #
    #   Document: $3
    #
    #   ``` ruby
    #   params = {
    #     combine_out_trade_no: 'combine_out_trade_no',
    #     combine_payer_info: {
    #       openid: 'client open id'
    #     },
    #     sub_orders: [
    #       {
    #         mchid: 'mchid',
    #         sub_mchid: 'sub mchid',
    #         attach: 'attach',
    #         amount: {
    #           total_amount: 100,
    #           currency: 'CNY'
    #         },
    #         out_trade_no: 'out_trade_no',
    #         description: 'description'
    #       }
    #     ],
    #     notify_url: 'the_url'
    #   }
    #
    #   WechatPay::Direct.invoke_combine_transactions_in_$1(params)
    #   ```
    #   @!method invoke_combine_transactions_in_$1
    #   @!scope class
    def self.define_combine_transaction_method(key, _value, _document)
      const_set("INVOKE_COMBINE_TRANSACTIONS_IN_#{key.upcase}_FIELDS",
                %i[combine_out_trade_no scene_info sub_orders notify_url].freeze)
      define_singleton_method("invoke_combine_transactions_in_#{key}") do |params|
        WechatPay::Ecommerce.send("invoke_combine_transactions_in_#{key}", params)
      end
    end

    define_combine_transaction_method('app', 'app', 'https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter5_1_1.shtml')
    define_combine_transaction_method('js', 'jsapi', 'https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter5_1_3.shtml')
    define_combine_transaction_method('h5', 'h5', 'https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter5_1_2.shtml')
    define_combine_transaction_method('miniprogram', 'jsapi', 'https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter5_1_4.shtml')
    define_combine_transaction_method('native', 'native', 'https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter5_1_5.shtml')

    QUERY_COMBINE_ORDER_FIELDS = %i[combine_out_trade_no].freeze # :nodoc:
    #
    # 合单查询
    #
    # TODO: 与电商平台相同，稍后重构
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_11.shtml
    #
    # ``` ruby
    # WechatPay::Direct.query_order(combine_out_trade_no: 'C202104302474')
    # ```
    #
    def self.query_combine_order(params)
      combine_out_trade_no = params.delete(:combine_out_trade_no)

      url = "/v3/combine-transactions/out-trade-no/#{combine_out_trade_no}"

      method = 'GET'

      make_request(
        method: method,
        path: url,
        extra_headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      )
    end

    CLOSE_COMBINE_ORDER_FIELDS = %i[combine_out_trade_no sub_orders].freeze # :nodoc:
    #
    # 关闭合单
    #
    # TODO: 与电商平台相同，稍后重构
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_11.shtml
    #
    # ``` ruby
    # WechatPay::Direct.close_combine_order(combine_out_trade_no: 'C202104302474')
    # ```
    def self.close_combine_order(params)
      combine_out_trade_no = params.delete(:combine_out_trade_no)

      url = "/v3/combine-transactions/out-trade-no/#{combine_out_trade_no}/close"

      payload = {
        combine_appid: WechatPay.app_id
      }.merge(params)

      payload_json = payload.to_json

      method = 'POST'

      make_request(
        method: method,
        for_sign: payload_json,
        payload: payload_json,
        path: url
      )
    end

    QUERY_ORDER_FIELDS = %i[out_trade_no transaction_id].freeze # :nodoc:
    #
    # 直连订单查询
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_2.shtml
    #
    # Example:
    #
    # ``` ruby
    # WechatPay::Direct.query_order(transaction_id: '4323400972202104305133344444') # by transaction_id
    # WechatPay::Direct.query_order(out_trade_no: 'N202104302474') # by out_trade_no
    # ```
    #
    def self.query_order(params)
      if params[:transaction_id]
        params.delete(:out_trade_no)
        transaction_id = params.delete(:transaction_id)
        path = "/v3/pay/transactions/id/#{transaction_id}"
      else
        params.delete(:transaction_id)
        out_trade_no = params.delete(:out_trade_no)
        path = "/v3/pay/transactions/out-trade-no/#{out_trade_no}"
      end

      params = params.merge({
                              mchid: WechatPay.mch_id
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

    CLOSE_ORDER_FIELDS = %i[out_trade_no].freeze # :nodoc:
    #
    # 关闭订单
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_3.shtml
    #
    # Example:
    #
    # ``` ruby
    # WechatPay::Direct.close_order(out_trade_no: 'N3344445')
    # ```
    #
    def self.close_order(params)
      out_trade_no = params.delete(:out_trade_no)
      url = "/v3/pay/transactions/out-trade-no/#{out_trade_no}/close"
      params = params.merge({
                              mchid: WechatPay.mch_id
                            })

      method = 'POST'

      make_request(
        method: method,
        path: url,
        for_sign: params.to_json,
        payload: params.to_json
      )
    end

    INVOKE_REFUND_FIELDS = %i[transaction_id out_trade_no out_refund_no amount].freeze # :nodoc:
    #
    # 退款申请
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_9.shtml
    #
    # Example:
    #
    # ``` ruby
    # WechatPay::Direct.invoke_refund(transaction_id: '4323400972202104305131070170', total: 1, refund: 1, out_refund_no: 'R10000')
    # WechatPay::Direct.invoke_refund(out_trade_no: 'N2021', total: 1, refund: 1, out_refund_no: 'R10000').body
    # ```
    def self.invoke_refund(params)
      url = '/v3/refund/domestic/refunds'
      method = 'POST'
      amount = {
        refund: params.delete(:refund),
        total: params.delete(:total),
        currency: 'CNY'
      }

      params = params.merge({
                              amount: amount
                            })

      make_request(
        path: url,
        method: method,
        for_sign: params.to_json,
        payload: params.to_json
      )
    end

    QUERY_REFUND_FIELDS = %i[sub_mchid refund_id out_refund_no].freeze # :nodoc:
    #
    # 直连退款查询
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_10.shtml
    #
    # Example:
    #
    # ``` ruby
    # WechatPay::Direct.query_refund(out_refund_no: 'R10000')
    # ```
    #
    def self.query_refund(params)
      out_refund_no = params.delete(:out_refund_no)
      url = "/v3/refund/domestic/refunds/#{out_refund_no}"

      method = 'GET'

      make_request(
        method: method,
        path: url,
        extra_headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      )
    end

    TRADEBILL_FIELDS = [:bill_date].freeze # :nodoc:
    #
    # 直连申请交易账单
    #
    # Todo: 跟商户平台接口相同
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_6.shtml
    #
    # Example:
    #
    # ``` ruby
    # WechatPay::direct.tradebill(bill_date: '2021-04-30')
    # ```
    def self.tradebill(params)
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

    FUNDFLOWBILL_FIELDS = [:bill_date].freeze # :nodoc:
    #
    # 申请资金账单
    #
    # Todo: 跟商户平台接口相同
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_7.shtml
    #
    # Example:
    #
    # ``` ruby
    # WechatPay::Direct.fundflowbill(bill_date: '2021-04-30')
    # ```
    #
    def self.fundflowbill(params)
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

    class << self
      private

      def direct_transactions_method_by_suffix(suffix, params)
        url = "/v3/pay/transactions/#{suffix}"
        method = 'POST'

        params = {
          mchid: WechatPay.mch_id,
          appid: WechatPay.app_id
        }.merge(params)

        payload_json = params.to_json

        make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json
        )
      end
    end
  end
end

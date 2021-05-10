# frozen_string_literal: true

require 'json'
require 'wechat_pay/helper'

module WechatPay
  module Ecommerce
    include WechatPayHelper

    class<<self
      # 二级商户进件
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter11_1_1.shtml
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
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter11_1_2.shtml
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
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_1_3.shtml
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
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter11_1_4.shtml
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

      # 修改结算账号, TODO 添加字段检测
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

      # app下单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_1.shtml
      #
      # Example:
      # params = {
      #   sp_appid: 'Your appid',
      #   sp_mchid: 'Your mchid',
      #   description: 'pay',
      #   out_trade_no: 'Order Number',
      #   payer: {
      #     sp_openid: 'wechat open id'
      #   },
      #   amount: {
      #     total: 10
      #   },
      #   sub_mchid: 'Your sub mchid',
      #   notify_url: 'the url'
      # }
      #
      # WechatPay::Ecommerce.invoke_transactions_in_app(params)
      #
      #
      # js或小程序下单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_2.shtml
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_3.shtml
      #
      # Example:
      # params = {
      #   sp_appid: 'Your appid',
      #   sp_mchid: 'Your mchid',
      #   description: 'pay',
      #   out_trade_no: 'Order Number',
      #   payer: {
      #     sp_openid: 'wechat open id'
      #   },
      #   amount: {
      #     total: 10
      #   },
      #   sub_mchid: 'Your sub mchid',
      #   notify_url: 'the url'
      # }
      #
      # WechatPay::Ecommerce.invoke_transactions_in_js(params)
      #
      #
      # h5下单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_4.shtml
      #
      # Example:
      # params = {
      #   sp_appid: 'Your appid',
      #   sp_mchid: 'Your mchid',
      #   description: 'pay',
      #   out_trade_no: 'Order Number',
      #   payer: {
      #     sp_openid: 'wechat open id'
      #   },
      #   amount: {
      #     total: 10
      #   },
      #   sub_mchid: 'Your sub mchid',
      #   notify_url: 'the url'
      # }
      #
      # WechatPay::Ecommerce.invoke_transactions_in_5(params)
      {
        js: 'jsapi',
        app: 'app',
        h5: 'h5'
      }.each do |key, value|
        const_set("INVOKE_TRANSACTIONS_IN_#{key.upcase}_FIELDS",
                  %i[sp_appid sp_mchid sub_mchid description out_trade_no notify_url amount])
        define_method("invoke_transactions_in_#{key}") do |params|
          url = "/v3/pay/partner/transactions/#{value}"
          method = 'POST'

          payload_json = params.to_json

          make_request(
            method: method,
            path: url,
            for_sign: payload_json,
            payload: payload_json
          )
        end
      end

      # 订单查询
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_5.shtml
      # 微信支付订单号查询
      # WechatPay::Ecommerce.query_order(sub_mchid: '16000008', transaction_id: '4323400972202104305133344444')
      # 商户订单号查询
      # WechatPay::Ecommerce.query_order(sub_mchid: '16000008', out_trade_no: 'N202104302474')
      QUERY_ORDER_FIELDS = %i[sub_mchid out_trade_no transaction_id].freeze
      def query_order(params)
        if params[:transaction_id]
          params.delete(:out_trade_no)
          transaction_id = params.delete(:transaction_id)
          path = "/v3/pay/partner/transactions/id/#{transaction_id}"
        else
          params.delete(:transaction_id)
          out_trade_no = params.delete(:out_trade_no)
          path = "/v3/pay/partner/transactions/out-trade-no/#{out_trade_no}"
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

      # 关闭订单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_6.shtml
      # WechatPay::Ecommerce.close_order(sub_mchid: '16000008', out_trade_no: 'N3344445')
      CLOSE_ORDER_FIELDS = %i[sub_mchid out_trade_no].freeze
      def close_order(params)
        out_trade_no = params.delete(:out_trade_no)
        url = "/v3/pay/partner/transactions/out-trade-no/#{out_trade_no}/close"
        params = params.merge({
                                sp_mchid: WechatPay.mch_id
                              })

        method = 'POST'

        make_request(
          method: method,
          path: url,
          for_sign: params.to_json,
          payload: params.to_json
        )
      end

      # app合单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_1.shtml
      #
      # Example:
      # params = {
      #   combine_appid: 'Your appid',
      #   combine_mchid: 'Your mchid',
      #   combine_out_trade_no: 'combine_out_trade_no',
      #   combine_payer_info: {
      #     openid: 'client open id'
      #   },
      #   sub_orders: [
      #     {
      #       mchid: 'mchid',
      #       sub_mchid: 'sub mchid',
      #       attach: 'attach',
      #       amount: {
      #         total_amount: 100,
      #         currency: 'CNY'
      #       },
      #       out_trade_no: 'out_trade_no',
      #       description: 'description'
      #     }
      #   ]
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_app(params)
      #
      #
      # js或小程序合单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_3.shtml
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_4.shtml
      #
      # Example:
      # params = {
      #   combine_appid: 'Your appid',
      #   combine_mchid: 'Your mchid',
      #   combine_out_trade_no: 'combine_out_trade_no',
      #   combine_payer_info: {
      #     openid: 'client open id'
      #   },
      #   sub_orders: [
      #     {
      #       mchid: 'mchid',
      #       sub_mchid: 'sub mchid',
      #       attach: 'attach',
      #       amount: {
      #         total_amount: 100,
      #         currency: 'CNY'
      #       },
      #       out_trade_no: 'out_trade_no',
      #       description: 'description'
      #     }
      #   ]
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_js(params)
      #
      #
      # h5合单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_2.shtml
      #
      # Example:
      # params = {
      #   combine_appid: 'Your appid',
      #   combine_mchid: 'Your mchid',
      #   combine_out_trade_no: 'combine_out_trade_no',
      #   sub_orders: [
      #     {
      #       mchid: 'mchid',
      #       sub_mchid: 'sub mchid',
      #       attach: 'attach',
      #       amount: {
      #         total_amount: 100,
      #         currency: 'CNY'
      #       },
      #       out_trade_no: 'out_trade_no',
      #       description: 'description'
      #     }
      #   ]
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_h5(params)
      #
      # native合单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_5.shtml
      #
      # Example:
      # params = {
      #   combine_appid: 'Your appid',
      #   combine_mchid: 'Your mchid',
      #   combine_out_trade_no: 'combine_out_trade_no',
      #   sub_orders: [
      #     {
      #       mchid: 'mchid',
      #       sub_mchid: 'sub mchid',
      #       attach: 'attach',
      #       amount: {
      #         total_amount: 100,
      #         currency: 'CNY'
      #       },
      #       out_trade_no: 'out_trade_no',
      #       description: 'description'
      #     }
      #   ]
      #   notify_url: 'the_url'
      # }
      #
      # WechatPay::Ecommerce.invoke_combine_transactions_in_native(params)
      {
        js: 'jsapi',
        app: 'app',
        h5: 'h5',
        native: 'native'
      }.each do |key, value|
        const_set("INVOKE_COMBINE_TRANSACTIONS_IN_#{key.upcase}_FIELDS",
                  %i[combine_appid combine_mchid combine_out_trade_no combine_payer_info sub_orders notify_url])
        define_method("invoke_combine_transactions_in_#{key}") do |params|
          url = "/v3/combine-transactions/#{value}"
          method = 'POST'

          payload_json = params.to_json

          make_request(
            method: method,
            path: url,
            for_sign: payload_json,
            payload: payload_json
          )
        end
      end

      # 合单查询
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_11.shtml
      # 商户合单号查询
      # WechatPay::Ecommerce.query_order(combine_out_trade_no: 'C202104302474')
      QUERY_COMBINE_ORDER_FIELDS = %i[combine_out_trade_no].freeze
      def query_combine_order(params)
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

      # 关闭合单
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_3_11.shtml
      # WechatPay::Ecommerce.close_combine_order(combine_out_trade_no: 'C202104302474')
      CLOSE_COMBINE_ORDER_FIELDS = %i[combine_out_trade_no sub_orders].freeze
      def close_combine_order(params)
        combine_out_trade_no = params.delete(:combine_out_trade_no)

        url = "/v3/combine-transactions/out-trade-no/#{combine_out_trade_no}/close"

        payload = {
          combine_appid: WechatPay.appid
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

      # 视频上传
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter2_1_2.shtml
      def media_video_upload(video)
        url = '/v3/merchant/media/video_upload'
        method = 'POST'
        meta = {
          filename: video.to_path,
          sha256: Digest::SHA256.hexdigest(video.read)
        }

        video.rewind
        payload = {
          meta: meta.to_json,
          file: video
        }

        make_request(
          method: method,
          path: url,
          for_sign: meta.to_json,
          payload: payload,
          extra_headers: {
            'Content-Type' => nil
          }
        )
      end

      # 图片上传
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter2_1_1.shtml
      def media_upload(image)
        url = '/v3/merchant/media/upload'
        method = 'POST'
        meta = {
          filename: image.to_path,
          sha256: Digest::SHA256.hexdigest(image.read)
        }

        image.rewind
        payload = {
          meta: meta.to_json,
          file: image
        }

        make_request(
          method: method,
          path: url,
          for_sign: meta.to_json,
          payload: payload,
          extra_headers: {
            'Content-Type' => nil # Pass nil to remove the Content-Type
          }
        )
      end
    end
  end
end

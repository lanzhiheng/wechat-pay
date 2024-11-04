# frozen_string_literal: true

module WechatPay
  module Ecommerce
    # 分账相关
    module Profitsharing
      REQUEST_PROFITSHARING_FIELDS = %i[out_trade_no transaction_id sub_mchid out_order_no receivers finish].freeze # :nodoc:
      #
      # 分账请求
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_4_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # params = {"out_trade_no"=>"P202104306585", "transaction_id"=>"4323400972202104301286330188", "sub_mchid"=>"160000", "out_order_no"=>"N202104307987", "finish"=>true, "receivers"=>[{"type"=>"MERCHANT_ID", "receiver_account"=>"1607189890", "amount"=>1, "description"=>"平台抽成", "receiver_name"=>"CXOO5SF5sylMhSWjUBHQ6dBN0BTdrGExiziO8OEnJEG/nAa7gw6JTbsFQVhUbXD2er07Gcvt7qsLg7wYEe6iqNKbHHRWvChVVKWcKSyvfMOcRa95lxUkVn2+YdMmQ/Rt2h+xN7HMFMVPh9Py2c3sxnv1hZSraTEBWp577NOVwfSKiDTOAnbLtVtLbJndZ2N/bRXzW/gpbQV6TnnsrKPJ+NQ64kCedaYoO0XvEK1JavJju4kUAw/TnJ78jBMwj0gx2kfrsAgtwGrIGhrqhGcGHwwwPPDk5lS/iVaKpSdMvxOHN/9mrAqgqmvBg9uHRKE4sUqkZWuaiAFvYF9/5sLgjQ=="}]}
      # WechatPay::Ecommerce.request_profitsharing(params)
      # ```
      def request_profitsharing(params)
        url = '/v3/ecommerce/profitsharing/orders'
        method = 'POST'
        params = {
          appid: @config.app_id
        }.merge(params)

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

      QUERY_PROFITSHARING_FIELDS = %i[out_order_no transaction_id sub_mchid].freeze # :nodoc:
      #
      # 分账结果查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_4_2.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_profitsharing(out_order_no: 'N202104288345', sub_mchid: '16000000', transaction_id: '4200001048202104280183691118')
      # ```
      #
      def query_profitsharing(params)
        method = 'GET'
        query = @client.build_query(params)
        path = '/v3/ecommerce/profitsharing/orders'
        url = "#{path}?#{query}"

        @client.make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      RETURN_PROFITSHARING_FIELDS = %i[sub_mchid order_id out_order_no out_return_no return_mchid amount description].freeze # :nodoc:
      #
      # 请求分账回退
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_4_3.shtml
      #
      # ``` ruby
      # WechatPay::Ecommerce.return_profitsharing(out_order_no: 'P202104306585', sub_mchid: '16000000', out_return_no: 'R20210430223', return_mchid: '180000', amount: 1, description: '分账回退')
      # WechatPay::Ecommerce.return_profitsharing(order_id: '3008450740201411110007820472', sub_mchid: '16000000', out_return_no: 'R20210430223', return_mchid: '180000', amount: 1, description: '分账回退')
      # ```
      def return_profitsharing(params)
        url = '/v3/ecommerce/profitsharing/returnorders'
        method = 'POST'

        payload_json = params.to_json

        @client.make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json
        )
      end

      QUERY_RETURN_PROFITSHARING_FIELDS = %i[sub_mchid order_id out_order_no out_return_no].freeze # :nodoc:
      #
      # 分账回退结果查询
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_4_4.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_return_profitsharing(sub_mchid: '1608747309', out_order_no: 'P202104306585', out_return_no: 'R202105023455')
      # WechatPay::Ecommerce.query_return_profitsharing(sub_mchid: '1608747309', order_id: '3008450740201411110007820472', out_return_no: 'R202105023455')
      # ```
      def query_return_profitsharing(params)
        method = 'GET'
        query = @client.build_query(params)
        path = '/v3/ecommerce/profitsharing/returnorders'
        url = "#{path}?#{query}"

        @client.make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      FINISH_PROFITSHARING_FIELDS = %i[transaction_id sub_mchid out_order_no description].freeze # :nodoc:
      #
      # 完结分账
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_4_5.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.finish_profitsharing(sub_mchid: '160000', out_order_no: 'P202104303106', transaction_id: '4323400972202104305131070133', description: '直接打款到二级商户不分账').bod
      # ```
      #
      def finish_profitsharing(params)
        url = '/v3/ecommerce/profitsharing/finish-order'
        method = 'POST'

        payload_json = params.to_json

        @client.make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json
        )
      end

      QUERY_PROFITSHARING_AMOUNT_FIELDS = %i[transaction_id].freeze # :nodoc:
      #
      # 查询订单剩余待分金额
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_4_9.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.query_profitsharing_amount({ transaction_id: '4323400972202104301286330188' })
      # ```
      #
      def query_profitsharing_amount(params)
        method = 'GET'
        transaction_id = params.delete(:transaction_id)
        url = "/v3/ecommerce/profitsharing/orders/#{transaction_id}/amounts"

        @client.make_request(
          path: url,
          method: method,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      ADD_PROFITSHARING_RECEIVERS_FIELDS = %i[type account name relation_type].freeze # :nodoc:
      #
      # 添加分账接收方
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_4_7.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.add_profitsharing_receivers(type: 'PERSONAL_OPENID', account: 'oly6s5cLmmVzzr8iPyI6mJj7qG2s', name: 'Lan', relation_type: 'DISTRIBUTOR').body
      # ```
      #
      def add_profitsharing_receivers(params)
        url = '/v3/ecommerce/profitsharing/receivers/add'
        method = 'POST'

        params = {
          appid: @config.app_id
        }.merge(params)

        payload_json = params.to_json

        @client.make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json
        )
      end

      DELETE_PROFITSHARING_RECEIVERS_FIELDS = %i[type account].freeze # :nodoc:
      #
      # 删除分账接收方
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_4_8.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.remove_profitsharing_receivers(type: 'PERSONAL_OPENID', account: 'oly6s5cLmmVzzr8iPyI6mJj7qG2s', name: 'Lan', relation_type: 'DISTRIBUTOR').body
      # ```
      #
      def delete_profitsharing_receivers(params)
        url = '/v3/ecommerce/profitsharing/receivers/delete'
        method = 'POST'

        params = {
          appid: @config.app_id
        }.merge(params)

        payload_json = params.to_json

        @client.make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json
        )
      end
    end
  end
end

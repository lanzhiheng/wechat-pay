# frozen_string_literal: true

require 'openssl'
require 'base64'
require 'securerandom'
require 'active_support/core_ext/hash'

module WechatPay
  # # 微信签名相关的封装
  # 文档: https://pay.weixin.qq.com/wiki/doc/apiv3/wechatpay/wechatpay4_0.shtml
  #
  # PS: 提供了常用的帮助方法，方便您的开发
  #
  class Sign
    [
      'generate_app_payment_params_from_prepay_id_and_appid', 'generate_payment_params_from_prepay_id_and_appid', 'notification_from_wechat?', 'sign_important_info',
      'decrypt_the_encrypt_params', 'build_authorization_header', 'sign_string', 'build_string',
      'build_callback_string', 'build_paysign_string', 'build_app_paysign_string'
    ].each do |method|
      define_singleton_method(method) do |*args|
        WechatPay.sign.send(method, *args)
      end
    end

    def initialize(config)
      @config = config
    end
    # Generate payment params with appid and prepay_id for invoking the wechat pay in app
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_7.shtml
    #
    # Take app for example
    #
    # ``` ruby
    # appid = 'appid for mobile'
    #
    # params = {
    #   sp_appid: 'Your appid',
    #   sp_mchid: 'Your mchid',
    #   description: 'pay',
    #   out_trade_no: 'Order Number',
    #   amount: {
    #     total: 10
    #   },
    #   sub_mchid: 'Your sub mchid',
    #   notify_url: 'the url'
    # }
    # result = WechatPay::Ecommerce.invoke_transactions_in_app(params).body
    # # => { prepay_id => 'wx201410272009395522657a690389285100' }
    # prepay_id = result['prepay_id']
    # WechatPay::Sign.generate_app_payment_params_from_prepay_id_and_appid(appid, prepay_id)
    # # => params for invoking the wechat pay in app
    # ```

    def generate_app_payment_params_from_prepay_id_and_appid(appid, prepay_id)
      timestamp = Time.now.to_i.to_s
      noncestr = SecureRandom.hex
      string = build_app_paysign_string(appid, timestamp, noncestr, prepay_id)

      {
        appId: appid,
        partnerId: @config.mch_id,
        timeStamp: timestamp,
        nonceStr: noncestr,
        prepayId: prepay_id,
        packageValue: 'Sign=WXPay',
        sign: sign_string(string)
      }.stringify_keys
    end

    # Generate payment params with appid and prepay_id for invoking the wechat pay in miniprogram
    #
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_8.shtml
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_9.shtml
    #
    # Take app for example
    #
    # ``` ruby
    # appid = 'appid for mobile'
    #
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
    # result = WechatPay::Ecommerce.invoke_transactions_in_miniprogram(params).body
    # # => { prepay_id => 'wx201410272009395522657a690389285100' }
    # prepay_id = result['prepay_id']
    # WechatPay::Sign.generate_payment_params_from_prepay_id_and_appid(appid, prepay_id)
    # # => params for invoking the wechat pay in miniprogram
    # ```
    def generate_payment_params_from_prepay_id_and_appid(appid, prepay_id)
      timestamp = Time.now.to_i.to_s
      noncestr = SecureRandom.hex
      string = build_paysign_string(appid, timestamp, noncestr, prepay_id)

      {
        timeStamp: timestamp,
        nonceStr: noncestr,
        package: "prepay_id=#{prepay_id}",
        paySign: sign_string(string),
        signType: 'RSA'
      }.stringify_keys
    end

    # For checkingi if the requests from wechat platform
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_11.shtml
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/wechatpay/wechatpay4_1.shtml
    #
    # Usage:
    #
    # ``` ruby
    # def pay_action
    #   timestamp = request.headers['Wechatpay-Timestamp']
    #   noncestr = request.headers['Wechatpay-Nonce']
    #   signature = request.headers['Wechatpay-Signature']
    #   body = JSON.parse(request.body.read)
    #   raise Exceptions::InvalidAction, '非法请求，请求并非来自微信' unless WechatV3.notification_from_wechat?(timestamp, noncestr, body.to_json, signature)
    #   # ....
    # end
    # ```
    def notification_from_wechat?(timestamp, noncestr, json_body, signature)
      string = build_callback_string(timestamp, noncestr, json_body)
      decoded_signature = Base64.strict_decode64(signature)
      @config.platform_cert.public_key.verify('SHA256', decoded_signature, string)
    end

    # For signing the sensitive information
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/wechatpay/wechatpay4_3.shtml
    #
    # Usage:
    #
    # ``` ruby
    # string = 'Ruby'
    # WechatPay::Sign.sign_important_info(string)
    # ```
    #
    # ``` ruby
    # # result
    # "K0MK7g3laREAQ4HIlpIndVmFdz4IyxxiVp42hXFx2CzWRB1fn85ANBxnQXESq91vJ1P9mCt94cHZDoshlEOJRkE1KvcxpBCnG3ghIqiSsLKdLZ3ytO94GBDzCt8nsq+vJKXJbK2XuL9p5h0KYGKZyjt2ydU9Ig6daWTpZH8lAKIsLzPTsaUtScuw/v3M/7t8/4py8N0MOLKbDBDnR5Q+MRHbEWI9nCA3HTAWsSerIIgE7igWnzybxsUzhkV8m49P/Shr2zh6yJAlEnyPLFmQG7GuUaYwDTSLKOWzzPYwxMcucWQha2krC9OlwnZJe6ZWUAI3s4ej4kFRfheOYywRoQ=="
    # ```
    def sign_important_info(string)
      platform_public_key = @config.platform_cert.public_key
      Base64.strict_encode64(platform_public_key.public_encrypt(string, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING))
    end

    # For Decrypting the encrypt params from wechat platform
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/wechatpay/wechatpay4_2.shtml
    #
    # Usage:
    #
    # ``` ruby
    # def pay_action
    #   # check if the request from wechat
    #   associated_data = body['resource']['associated_data']
    #   nonce = body['resource']['nonce']
    #   ciphertext = body['resource']['ciphertext']
    #   res = WechatPay::Sign.decrypt_the_encrypt_params(
    #     associated_data: associated_data,
    #     nonce: nonce,
    #     ciphertext: ciphertext
    #   )
    #   result = JSON.parse(res) # Get the real params
    # end
    # ```
    #
    def decrypt_the_encrypt_params(associated_data:, nonce:, ciphertext:)
      # https://contest-server.cs.uchicago.edu/ref/ruby_2_3_1_stdlib/libdoc/openssl/rdoc/OpenSSL/Cipher.html
      tag_length = 16
      decipher = OpenSSL::Cipher.new('aes-256-gcm').decrypt
      decipher.key = @config.mch_key
      decipher.iv = nonce
      signature = Base64.strict_decode64(ciphertext)
      length = signature.length
      real_signature = signature.slice(0, length - tag_length)
      tag = signature.slice(length - tag_length, length)
      decipher.auth_tag = tag
      decipher.auth_data = associated_data
      decipher.update(real_signature)
    end

    # Build authorization header for request
    #
    # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/wechatpay/wechatpay4_0.shtml
    #
    # Usage:
    #
    # ``` ruby
    # method = 'GET'
    # url = '/v3/certificates'
    # json_body = ''
    # WechatPay::sign.build_authorization_header(method, url, json_body)
    # ```
    #
    # ``` ruby
    # # Result
    # "WECHATPAY2-SHA256-RSA2048 mchid=\"16000000\",nonce_str=\"42ac357637f9331794e0c6fb3b3de048\",serial_no=\"0254A801C0\",signature=\"WBJaWlVFur5OGQ/E0ZKIlSDhR8WTNrkW2oCECF3Udrh8BVlnfYf5N5ROeOt9PBxdwD0+ufFQANZKugmXDNat+sFRY2DrIzdP3qYvFIzaYjp6QEtB0UPzvTgcLDULGbwCSTNDxvKRDi07OXPFSmVfmA5SbpbfumgjYOfzt1wcl9Eh+/op/gAB3N010Iu1w4OggR78hxQvPb9GIscuKHjaUWqqwf6v+p3/b0tiSO/SekJa3bMKPhJ2wJj8utBHQtbGO+iUQj1n90naL25MNJUM2XYocv4MasxZZgZnV3v1dtRvFkVo0ApqFyDoiRndr1Q/jPh+wmsb80LuhZ1S4eNfew==\",timestamp=\"1620571488\""
    # ```
    def build_authorization_header(method, url, json_body)
      timestamp = Time.now.to_i
      nonce_str = SecureRandom.hex
      string = build_string(method, url, timestamp, nonce_str, json_body)
      signature = sign_string(string)

      params = {
        mchid: @config.mch_id,
        nonce_str: nonce_str,
        serial_no: @config.apiclient_serial_no,
        signature: signature,
        timestamp: timestamp
      }

      params_string = params.stringify_keys.map { |key, value| "#{key}=\"#{value}\"" }.join(',')

      "WECHATPAY2-SHA256-RSA2048 #{params_string}"
    end

    def sign_string(string)
      result = @config.apiclient_key.sign('SHA256', string) # 商户私钥的SHA256-RSA2048签名
      Base64.strict_encode64(result) # Base64处理
    end

    private

    def build_string(method, url, timestamp, noncestr, body)
      "#{method}\n#{url}\n#{timestamp}\n#{noncestr}\n#{body}\n"
    end

    def build_callback_string(timestamp, noncestr, body)
      "#{timestamp}\n#{noncestr}\n#{body}\n"
    end

    def build_paysign_string(appid, timestamp, noncestr, prepayid)
      "#{appid}\n#{timestamp}\n#{noncestr}\nprepay_id=#{prepayid}\n"
    end

    def build_app_paysign_string(appid, timestamp, noncestr, prepayid)
      "#{appid}\n#{timestamp}\n#{noncestr}\n#{prepayid}\n"
    end
  end
end

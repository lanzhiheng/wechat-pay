require 'openssl'
require 'base64'
require 'securerandom'
require "active_support/core_ext/hash"

module WechatPay
  module Sign
    class<<self
      def notification_from_wechat?(timestamp, noncestr, json_body, signature)
        string = build_callback_string(timestamp, noncestr, json_body)
        decoded_signature = Base64.strict_decode64(signature)
        WechatPay.platform_cert.public_key.verify('SHA256', decoded_signature, string)
      end

      def build_authorization_header(method, url, json_body)
        timestamp = Time.now.to_i
        nonce_str = SecureRandom.hex
        string = build_string(method, url, timestamp, nonce_str, json_body)
        signature = sign_string(string)

        params = {
          mchid: WechatPay.mch_id,
          nonce_str: nonce_str,
          serial_no: WechatPay.apiclient_serial_no,
          signature: signature,
          timestamp: timestamp
        }

        params_string = params.stringify_keys.map { |key, value| "#{key}=\"#{value}\"" }.join(',')

        "WECHATPAY2-SHA256-RSA2048 #{params_string}"
      end

      def sign_important_info(string)
        platform_public_key = WechatPay.platform_cert.public_key
        Base64.strict_encode64(platform_public_key.public_encrypt(string, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING))
      end

      def decrypt_the_encrypt_params(associated_data:, nonce:, ciphertext:)
        # https://contest-server.cs.uchicago.edu/ref/ruby_2_3_1_stdlib/libdoc/openssl/rdoc/OpenSSL/Cipher.html
        tag_length = 16
        decipher = OpenSSL::Cipher.new('aes-256-gcm').decrypt
        decipher.key = WechatPay.mch_key
        decipher.iv = nonce
        signature = Base64.strict_decode64(ciphertext)
        length = signature.length
        real_signature = signature.slice(0, length - tag_length)
        tag = signature.slice(length - tag_length, length)
        decipher.auth_tag = tag
        decipher.auth_data = associated_data
        decipher.update(real_signature)
      end

      def sign_string(string)
        result = WechatPay.apiclient_key.sign('SHA256', string) # 商户私钥的SHA256-RSA2048签名
        Base64.strict_encode64(result) # Base64处理
      end

      private

      def build_string(method, url, timestamp, noncestr, body)
        "#{method}\n#{url}\n#{timestamp}\n#{noncestr}\n#{body}\n"
      end

      def build_paysign_string(appid, timestamp, noncestr, prepayid)
        "#{appid}\n#{timestamp}\n#{noncestr}\nprepay_id=#{prepayid}\n"
      end

      def build_callback_string(timestamp, noncestr, body)
        "#{timestamp}\n#{noncestr}\n#{body}\n"
      end
    end
  end
end

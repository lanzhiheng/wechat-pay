require 'test_helper'

class WechatPay::SignTest < MiniTest::Test
  def setup
    @wechat_platform_key = OpenSSL::PKey::RSA.new(File.read('test/fixtures/random_platform_key.pem'))
  end

  def test_sign_important_info
    important_text = 'Ruby'
    signature = WechatPay::Sign.sign_important_info(important_text)
    result = @wechat_platform_key.private_decrypt(Base64.strict_decode64(signature), OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
    assert_equal important_text, result
  end

  def test_decrypt_the_encrypt_params_from_wechat
    data = "Very, very confidential data"
    nonce = '46e4d8f11f62' # 必须是12个字节
    associated_data = 'transaction'
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt
    cipher.key = WechatPay.mch_key
    cipher.iv =  nonce
    cipher.auth_data = associated_data
    encrypted = cipher.update(data) + cipher.final
    tag = cipher.auth_tag # produces 16 bytes tag by default
    ciphertext = Base64.strict_encode64(encrypted + tag)

    result = WechatPay::Sign.decrypt_the_encrypt_params(
      associated_data: associated_data,
      nonce: nonce,
      ciphertext: ciphertext
    )
    assert_equal data, result
  end

  def test_if_notifications_from_wechat
    timestamp = 1600000
    noncestr = 'hhhhhhh'
    body = { name: 'Ruby', age: '26' }.to_json
    callback_string = WechatPay::Sign.send(:build_callback_string, timestamp, noncestr, body)
    signature = Base64.strict_encode64(@wechat_platform_key.sign('SHA256', callback_string))

    assert_equal true, WechatPay::Sign.notification_from_wechat?(timestamp, noncestr, body, signature)
  end

  def test_build_authorization_header
    timestamp = Time.at(1600000)
    hex = 'hhhhhhhhh'

    Time.stub :now, timestamp do
      SecureRandom.stub :hex, hex do
        authorization_header = WechatPay::Sign.build_authorization_header('GET', '/v3/api/wechat_pay', { name: 'Ruby' }.to_json)
        expected_string = 'WECHATPAY2-SHA256-RSA2048 mchid="%{mchid}",nonce_str="%{hex}",serial_no="%{serial_no}",signature="b61tFFRwxJgzO+QeTHiRxxiOpniZCK2cwUtnBEE7QVe06k3tNjfIaXtrOOSc3Gr84mx9xlQePM7s2cf1B3ixYKnvcJiTNnUsQwU9omyyUSjO1YIdwQTrra1r6+VUmM7pAq1eowa/WQhvAP2QkG2J4ienMwNtVuHb4Tw7X1R7LSh2/DEl+LmYCtEd7Acc4AMFyLE/rqdN19fdO+ZSTpVy0rTDMSsgpCACP8Xi7lQFyej9Gb72XYq0oHelWpCSyIRoWm7214ck76ytcgPIe15jOpLYO+L2cYf5VSMPAJ9neX45udpBuYXJWC6NchHko/HNN473zlNqOb6gCqwugzkvNg==",timestamp="%{timestamp}"' % { timestamp: timestamp.to_i, mchid: WechatPay.mch_id, hex: hex, serial_no: WechatPay.apiclient_serial_no }
        assert_equal expected_string, authorization_header
      end
    end
  end

  def test_sign_string_with_sha256
    test_string = 'Hello Ruby'
    signature = WechatPay::Sign.sign_string(test_string)
    apiclient_public_key = WechatPay.apiclient_cert.public_key
    decoded_signature = Base64.strict_decode64(signature)
    assert true, apiclient_public_key.verify('SHA256', decoded_signature, test_string)
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'WechatPay::Sign' do
  before do
    @wechat_platform_key = OpenSSL::PKey::RSA.new(File.read('spec/fixtures/random_platform_key.pem'))
  end

  it 'generate miniprogramming payment params from prepay id and appid' do
    timestamp = Time.at(1_600_000)
    hex = 'hhhhhhhhh'
    appid = 'wx18802234'
    prepay_id = 'prepay_id'

    expect(Time).to receive(:now).with(any_args).and_return(timestamp)
    expect(SecureRandom).to receive(:hex).with(any_args).and_return(hex)

    params = WechatPay::Sign.generate_app_payment_params_from_prepay_id_and_appid(appid, prepay_id)
    result = { 'partnerId' => WechatPay.config.mch_id, 'appId' => appid, 'packageValue' => 'Sign=WXPay', 'timeStamp' => '1600000', 'nonceStr' => 'hhhhhhhhh', 'prepayId' => prepay_id, 'sign' => 'iGxYj/P4E4PG8bnCmLWCXn4sRxumpPY2d7Z6LuRvHPgTh7vB61d/fS9jGKBLooqxRUpS0of6egMVGmbNKa1tYj028P5AGIdfkfdIQcYpL9gHTvDfW0abZ1GK+79HtlcHXkuwJS6E8N1Q/ZliG9csCzB5AwzW40PGilDWzMzfkycvQkcuR0jhLx+RWMWFU1SupBqogT7KwX0En1956zKM0lRWMpclvH8BWqGgMxuFOy0pUCjYGSyUtlaP42p8vL+WLyw/JT70QQsmRCnCYAi8l7uSq3YKRc7JTA7WBmkrhU8lvNbyCz7YmIOspkWMgyBPuX5qjcl0EGhHZy3EDq6/Dg==' }
    expect(params).to eq(result)
  end

  it 'generate miniprogramming payment params from prepay id and appid' do
    timestamp = Time.at(1_600_000)
    hex = 'hhhhhhhhh'
    appid = 'wx18802234'
    prepay_id = 'prepay_id'

    expect(Time).to receive(:now).with(any_args).and_return(timestamp)
    expect(SecureRandom).to receive(:hex).with(any_args).and_return(hex)

    params = WechatPay::Sign.generate_payment_params_from_prepay_id_and_appid(appid, prepay_id)
    result = { 'timeStamp' => '1600000', 'nonceStr' => 'hhhhhhhhh', 'package' => 'prepay_id=prepay_id',
               'paySign' => 'aTNV10+9mzmONvPuL6lSW+LRvNa1Z3LVAVTAKjYyJ7LmgHjIZ8piKNBBOCRx5l+71QBZoFBDqEjAfi4rHdSIaO4vGfAXxNqsZNjueNlE1yQEgKHDarYWV/uLuxzNCgG1vwz6cTzP8TvCXsihrL43duNxNNgR8ERxGs5/IOXKANc59vlYW1eeOjc98Q+0J1OQPlTIMDzFXqjf9i9dkGdJfFG5Z+bDceeDcGhZEw8+T6kJSvWRZxRzJ1C7NKR2ITkX7Yg9joxz6oCwhfcsrnOkOI8gwdK/L/OKjP7TQzntQKWjfYAcmdOUTuXhLpymcunUkKUd0gXv3SNwFdQk0vzmMg==', 'signType' => 'RSA' }
    expect(params).to eq(result)
  end

  it 'build authorization header' do
    timestamp = Time.at(1_600_000)
    hex = 'hhhhhhhhh'

    expect(Time).to receive(:now).with(any_args).and_return(timestamp)
    expect(SecureRandom).to receive(:hex).with(any_args).and_return(hex)

    authorization_header = WechatPay::Sign.build_authorization_header('GET', '/v3/api/wechat_pay',
                                                                      { name: 'Ruby' }.to_json)
    expected_string = format(
      'WECHATPAY2-SHA256-RSA2048 mchid="%<mchid>s",nonce_str="%<hex>s",serial_no="%<serial_no>s",signature="b61tFFRwxJgzO+QeTHiRxxiOpniZCK2cwUtnBEE7QVe06k3tNjfIaXtrOOSc3Gr84mx9xlQePM7s2cf1B3ixYKnvcJiTNnUsQwU9omyyUSjO1YIdwQTrra1r6+VUmM7pAq1eowa/WQhvAP2QkG2J4ienMwNtVuHb4Tw7X1R7LSh2/DEl+LmYCtEd7Acc4AMFyLE/rqdN19fdO+ZSTpVy0rTDMSsgpCACP8Xi7lQFyej9Gb72XYq0oHelWpCSyIRoWm7214ck76ytcgPIe15jOpLYO+L2cYf5VSMPAJ9neX45udpBuYXJWC6NchHko/HNN473zlNqOb6gCqwugzkvNg==",timestamp="%<timestamp>s"', timestamp: timestamp.to_i, mchid: WechatPay.config.mch_id, hex: hex, serial_no: WechatPay.config.apiclient_serial_no
    )
    expect(authorization_header).to eq(expected_string)
  end

  it 'sign string with sha256' do
    test_string = 'Hello Ruby'
    signature = WechatPay::Sign.sign_string(test_string)
    apiclient_public_key = WechatPay.config.apiclient_cert.public_key
    decoded_signature = Base64.strict_decode64(signature)
    expect(apiclient_public_key.verify('SHA256', decoded_signature, test_string)).to eq(true)
  end

  it 'sign important info' do
    important_text = 'Ruby'
    signature = WechatPay::Sign.sign_important_info(important_text)
    result = @wechat_platform_key.private_decrypt(Base64.strict_decode64(signature),
                                                  OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
    expect(result).to eq(important_text)
  end

  it 'decrypt the encrypt params from wechat' do
    data = 'Very, very confidential data'
    nonce = '46e4d8f11f62' # 必须是12个字节
    associated_data = 'transaction'
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt
    cipher.key = WechatPay.config.mch_key
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
    expect(data).to eq(result)
  end

  it 'if notifications from wechat' do
    timestamp = 1_600_000
    noncestr = 'hhhhhhh'
    body = { name: 'Ruby', age: '26' }.to_json
    callback_string = WechatPay::Sign.send(:build_callback_string, timestamp, noncestr, body)
    signature = Base64.strict_encode64(@wechat_platform_key.sign('SHA256', callback_string))

    expect(WechatPay::Sign.notification_from_wechat?(timestamp, noncestr, body, signature)).to eq(true)
  end
end

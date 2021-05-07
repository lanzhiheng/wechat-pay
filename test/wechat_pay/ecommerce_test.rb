require 'pry'
require 'test_helper'

class WechatPay::EcommerceTest < MiniTest::Test
  def check_result(status, code, result)
    assert_equal status, result.code
    assert_equal code, JSON.parse(result.body)['code']
  end

  def test_applyment
    result = WechatPay::Ecommerce.applyment({})
    check_result(401, 'SIGN_ERROR', result)
  end

  def test_query_settlement
    result = WechatPay::Ecommerce.query_settlement({ sub_mchid: '444444444' })
    check_result(401, 'SIGN_ERROR', result)
  end

  def test_get_certificates
    result = WechatPay::Ecommerce.get_certificates
    check_result(401, 'SIGN_ERROR', result)
  end

  def test_modify_settlement
    result = WechatPay::Ecommerce.modify_settlement({ sub_mchid: '444444444' })
    check_result(401, 'SIGN_ERROR', result)
  end

  def test_applyment_query
    result = WechatPay::Ecommerce.query_applyment({ applyment_id: '444444444' })
    check_result(401, 'SIGN_ERROR', result)
  end

  def test_media_upload
    result = WechatPay::Ecommerce.media_upload(File.open('Gemfile'))
    check_result(401, 'SIGN_ERROR', result)
  end

  def test_media_video_upload
    result = WechatPay::Ecommerce.media_video_upload(File.open('Gemfile'))
    check_result(401, 'SIGN_ERROR', result)
  end
end

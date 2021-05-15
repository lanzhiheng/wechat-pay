# frozen_string_literal: true

require 'pry'
require 'test_helper'

module WechatPay
  class DirectTest < MiniTest::Test
    ['js', 'miniprogram', 'app', 'h5', 'native'].each do |key|
      define_method("test_invoke_transactions_in_#{key}") do
        result = { code: 200 }
        WechatPay::Direct.stub :make_request, result do
          assert_equal WechatPay::Direct.const_get("invoke_transactions_in_#{key}_fields".upcase).is_a?(Array), true
          assert_equal WechatPay::Direct.send("invoke_transactions_in_#{key}", {}), result
        end
      end
    end

    ['native', 'miniprogram', 'app', 'h5', 'js'].each do |key|
      define_method("test_invoke_combine_transactions_in_#{key}") do
        result = { code: 200 }
        WechatPay::Ecommerce.stub :make_request, result do
          assert_equal WechatPay::Direct.const_get("invoke_combine_transactions_in_#{key}_fields".upcase).is_a?(Array), true
          assert_equal WechatPay::Direct.send("invoke_combine_transactions_in_#{key}", {}), result
        end
      end
    end
  end
end

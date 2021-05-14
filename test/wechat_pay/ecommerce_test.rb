# frozen_string_literal: true

require 'pry'
require 'test_helper'

module WechatPay
  class EcommerceTest < MiniTest::Test
    ['js', 'miniprogram', 'app', 'h5'].each do |key|
      define_method("test_invoke_transactions_in_#{key}") do
        result = { code: 200 }
        WechatPay::Ecommerce.stub :make_request, result do
          assert_equal WechatPay::Ecommerce.const_get("invoke_transactions_in_#{key}_fields".upcase).is_a?(Array), true
          assert_equal WechatPay::Ecommerce.send("invoke_transactions_in_#{key}", {}), result
        end
      end
    end

    ['native', 'miniprogram', 'app', 'h5', 'js'].each do |key|
      define_method("test_invoke_combine_transactions_in_#{key}") do
        result = { code: 200 }
        WechatPay::Ecommerce.stub :make_request, result do
          assert_equal WechatPay::Ecommerce.const_get("invoke_combine_transactions_in_#{key}_fields".upcase).is_a?(Array), true
          assert_equal WechatPay::Ecommerce.send("invoke_combine_transactions_in_#{key}", {}), result
        end
      end
    end
  end
end

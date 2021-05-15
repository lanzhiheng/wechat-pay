# frozen_string_literal: true

RSpec.describe "WechatPay::Direct" do
  ['js', 'miniprogram', 'app', 'h5', 'native'].each do |key|
    it "check method invoke_transactions_in_#{key}" do
      result = { code: 200 }
      expect(WechatPay::Direct).to receive(:make_request).with(any_args).and_return(result)
      expect(WechatPay::Direct.send("invoke_transactions_in_#{key}", {})).to eq(result)
    end
  end

  ['native', 'miniprogram', 'app', 'h5', 'js'].each do |key|
    it "check method invoke_combine_transactions_in_#{key}" do
      result = { code: 200 }
      expect(WechatPay::Ecommerce).to receive(:make_request).with(any_args).and_return(result)
      expect(WechatPay::Direct.const_get("invoke_combine_transactions_in_#{key}_fields".upcase).is_a?(Array)).to be(true)
      expect(WechatPay::Direct.send("invoke_combine_transactions_in_#{key}", {})).to eq(result)
    end
  end
end

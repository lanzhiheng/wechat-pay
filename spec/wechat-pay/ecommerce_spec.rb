# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'WechatPay::Ecommerce' do
  %w[js miniprogram app h5 native].each do |key|
    it "check method invoke_transactions_in_#{key}" do
      result = { code: 200 }
      expect_any_instance_of(WechatPay::Client).to receive(:make_request).with(any_args).and_return(result)
      expect(WechatPay::Ecommerce::Ecommerce.const_get("invoke_transactions_in_#{key}_fields".upcase).is_a?(Array)).to be(true)
      expect(WechatPay::Ecommerce.send("invoke_transactions_in_#{key}", {})).to eq(result)
    end
  end

  %w[native miniprogram app h5 js].each do |key|
    it "check method invoke_combine_transactions_in_#{key}" do
      result = { code: 200 }
      expect_any_instance_of(WechatPay::Client).to receive(:make_request).with(any_args).and_return(result)
      expect(WechatPay::Ecommerce::Ecommerce.const_get("invoke_combine_transactions_in_#{key}_fields".upcase).is_a?(Array)).to be(true)
      expect(WechatPay::Ecommerce.send("invoke_combine_transactions_in_#{key}", {})).to eq(result)
    end
  end

  it 'check media_video_upload method' do
    result = { code: 200 }
    f = File.open('spec/fixtures/random_apiclient_key.pem')
    expect_any_instance_of(WechatPay::Client).to receive(:make_request).with(any_args).and_return(result)
    expect(WechatPay::Ecommerce.media_video_upload(f)).to eq(result)
  end

  it 'check media_upload method' do
    result = { code: 200 }
    f = File.open('spec/fixtures/random_apiclient_key.pem')
    expect_any_instance_of(WechatPay::Client).to receive(:make_request).with(any_args).and_return(result)
    expect(WechatPay::Ecommerce.media_upload(f)).to eq(result)
  end
end

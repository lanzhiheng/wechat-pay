# frozen_string_literal: true

require 'json'
require 'wechat-pay/helper'
require 'wechat-pay/ecommerce/withdraw'
require 'wechat-pay/ecommerce/balance'
require 'wechat-pay/ecommerce/applyment'
require 'wechat-pay/ecommerce/order'
require 'wechat-pay/ecommerce/combine_order'
require 'wechat-pay/ecommerce/profitsharing'
require 'wechat-pay/ecommerce/subsidies'
require 'wechat-pay/ecommerce/refund'
require 'wechat-pay/ecommerce/bill'

module WechatPay
  module Ecommerce
    include WechatPayHelper

    class<<self
      # 视频上传
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter2_1_2.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.media_video_upload(File.open('Your Video'))
      # ```
      #
      def media_video_upload(video)
        url = '/v3/merchant/media/video_upload'
        method = 'POST'
        meta = {
          filename: video.to_path,
          sha256: Digest::SHA256.hexdigest(video.read)
        }

        video.rewind
        payload = {
          meta: meta.to_json,
          file: video
        }

        make_request(
          method: method,
          path: url,
          for_sign: meta.to_json,
          payload: payload,
          extra_headers: {
            'Content-Type' => nil
          }
        )
      end

      # 图片上传
      #
      # Document: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter2_1_1.shtml
      #
      # Example:
      #
      # ``` ruby
      # WechatPay::Ecommerce.media_upload(File.open('Your Image'))
      # ```
      def media_upload(image)
        url = '/v3/merchant/media/upload'
        method = 'POST'
        meta = {
          filename: image.to_path,
          sha256: Digest::SHA256.hexdigest(image.read)
        }

        image.rewind
        payload = {
          meta: meta.to_json,
          file: image
        }

        make_request(
          method: method,
          path: url,
          for_sign: meta.to_json,
          payload: payload,
          extra_headers: {
            'Content-Type' => nil # Pass nil to remove the Content-Type
          }
        )
      end
    end
  end
end

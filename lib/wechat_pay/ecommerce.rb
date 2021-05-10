# frozen_string_literal: true

require 'json'
require 'wechat_pay/helper'
require 'wechat_pay/ecommerce/withdraw'
require 'wechat_pay/ecommerce/balance'
require 'wechat_pay/ecommerce/applyment'
require 'wechat_pay/ecommerce/order'
require 'wechat_pay/ecommerce/combine_order'
require 'wechat_pay/ecommerce/profitsharing'

module WechatPay
  module Ecommerce
    include WechatPayHelper

    class<<self
      # 视频上传
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter2_1_2.shtml
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
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter2_1_1.shtml
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

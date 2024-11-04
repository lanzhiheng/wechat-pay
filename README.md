# Wechat Pay

A simple Wechat pay ruby gem, without unnecessary magic or wrapper. Just a simple wrapper for api V3. Refer to [wx_pay](https://github.com/jasl/wx_pay)

Please read official document first: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/pages/index.shtml

If you want check the present public api, you can find them in the [Document](https://www.rubydoc.info/github/lanzhiheng/wechat-pay/master/index)。

Summary:

`WechatPay::Direct` will contain the public api for direct connection merchant（直连商户）and `WechatPay::Ecommerce` will contain the public api for ecommerce（服务商，电商平台）。For more detail you can refer to the wechat document.

- 直连商户: https://pay.weixin.qq.com/wiki/doc/apiv3/index.shtml
- 服务商: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/index.shtml
- 电商平台（电商收付通）: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/open/pay/chapter3_3_3.shtml

If you find any issue in this repo, don't shy to create issues https://github.com/lanzhiheng/wechat-pay/issues

For more Information，you can check my posts: https://www.lanzhiheng.com/posts/preview/ruby-gem-for-wechat-pay-v3

# Installation

Add this line to your Gemfile:

```
gem 'wechat-pay'
```

or development version

```
gem 'wechat-pay', :github => 'lanzhiheng/wechat-pay'
```

And then execute:

```
$ bundle
```

# Usage

## Configuration

Create `config/initializer/wechat_pay.rb`and put following configurations into it

``` ruby
WechatPay.configure do |config|
  WechatPay.apiclient_key = File.read('apiclient_key.pem')
  WechatPay.platform_cert = File.read('platform_cert.pem') # You should comment this line before downloaded platform_cert.
  WechatPay.apiclient_cert = File.read('apiclient_cert.pem')
  WechatPay.app_id = 'Your App Id'
  WechatPay.mch_id = 'Your Mch Id'
  WechatPay.mch_key = 'Your Mch Key'
end
```

## Download

I will provide a simple script for you to download the platform_cert

``` ruby
def download_certificate
  download_path = 'Your Download Path'
  raise '必须提供证书下载路径' if download_path.blank?

  response = WechatPay::Ecommerce.certificates

  raise '证书下载失败' unless response.code == 200

  result = JSON.parse(response.body)
  # 需要按生效日期进行排序，获取最新的证书
  array = result['data'].sort_by { |item| -Time.parse(item['effective_time']).to_i }
  current_data = array.first
  encrypt_certificate = current_data['encrypt_certificate']
  associated_data = encrypt_certificate['associated_data']
  nonce = encrypt_certificate['nonce']
  ciphertext = encrypt_certificate['ciphertext']

  content = WechatPay::Sign.decrypt_the_encrypt_params(
    associated_data: associated_data,
    nonce: nonce,
    ciphertext: ciphertext
  )

  File.open(download_path, 'w') do |f|
    f.write(content)
  end

  puts '证书下载成功'
end
```



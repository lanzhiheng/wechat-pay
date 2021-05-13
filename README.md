# Wechat Pay

A simple Wechat pay ruby gem, without unnecessary magic or wrapper. Just a simple wrapper for api V3. Refer to [wx_pay](https://github.com/jasl/wx_pay)

Please read official document first: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/pages/index.shtml

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
WechatPay.apiclient_key = File.read('apiclient_key.pem')
WechatPay.platform_cert = File.read('platform_cert.pem')
WechatPay.apiclient_cert = File.read('apiclient_cert.pem')
WechatPay.app_id = 'Your App Id'
WechatPay.mch_id = 'Your Mch Id'
WechatPay.mch_key = 'Your Mch Key'
```



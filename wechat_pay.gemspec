$:.push File.expand_path("../lib", __FILE__)

require "wechat_pay/version"

Gem::Specification.new do |s|
  s.name        = 'wechat-pay'
  s.version     = WechatPay::VERSION
  s.summary     = "Wechat Pay in api V3"
  s.description = "A simple Wechat pay ruby gem in api V3."
  s.authors     = ["lanzhiheng"]
  s.email       = 'lanzhiheng@gmail.com'
  s.files       = ["lib/wechat_pay.rb"]
  s.require_paths = ["lib"]
  s.homepage    = 'https://github.com/lanzhiheng/wechat_pay'
  s.license       = 'MIT'

  s.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.0'
end

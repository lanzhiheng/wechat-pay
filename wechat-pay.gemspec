# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'wechat-pay/version'

Gem::Specification.new do |s|
  s.name        = 'wechat-pay'
  s.version     = WechatPay::VERSION
  s.summary     = 'Wechat Pay in api V3'
  s.description = 'A simple Wechat pay ruby gem in api V3.'
  s.authors     = ['lanzhiheng']
  s.email       = 'lanzhihengrj@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.require_paths = ['lib']
  s.homepage = 'https://rubygems.org/gems/wechat-pay'
  s.metadata = { "source_code_uri" => "https://github.com/lanzhiheng/wechat-pay" }
  s.license = 'MIT'

  s.add_runtime_dependency 'activesupport', '>= 3.2'
  s.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.0'
  s.add_development_dependency 'minitest', '~> 5.14.4'
  s.add_development_dependency 'rake', '~> 13.0', '>= 13.0.3'
end

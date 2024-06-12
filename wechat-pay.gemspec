# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'wechat-pay/version'

Gem::Specification.new do |s|
  s.name        = 'wechat-pay'
  s.version     = WechatPay::VERSION
  s.summary     = 'Wechat Pay in api V3'
  s.description = 'A simple Wechat pay ruby gem in api V3.'
  s.authors     = ['lanzhiheng']
  s.email       = 'lanzhihengrj@gmail.com'
  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.required_ruby_version = '>= 2.6'
  s.require_paths = ['lib']
  s.homepage = 'https://github.com/lanzhiheng/wechat-pay/'
  s.license = 'MIT'

  s.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.0'
  s.add_development_dependency 'rake', '~> 13.0', '>= 13.0.3'
  s.add_development_dependency 'rspec', '~> 3.10.0'
  s.add_development_dependency 'rubocop', '~> 1.14.0'
end

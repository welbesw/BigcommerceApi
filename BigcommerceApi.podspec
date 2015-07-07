#
# Be sure to run `pod lib lint BigcommerceApi.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BigcommerceApi"
  s.version          = "0.1.0"
  s.summary          = "A simple Swift library to access the BigCommerce API."
  s.description      = <<-DESC
                       An optional longer description of BigcommerceApi

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/welbesw/BigcommerceApi"
  s.license          = 'MIT'
  s.author           = { "William Welbes" }
  s.source           = { :git => "https://github.com/welbesw/BigcommerceApi.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/welbes'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'BigcommerceApi' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Alamofire', '~> 1.2'
end

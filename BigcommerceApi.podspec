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
  s.version          = "0.4.13"
  s.summary          = "A simple Swift library to access the Bigcommerce Stores API."
  s.description      = <<-DESC
                       A simple Swift library for the Bigcommerce Stores API
                       An implementation of the order method is the starting point.

                      More information about the Bigcommerce Stores API can be found at: https://developer.bigcommerce.com/api/legacy/basic-auth

                       DESC
  s.homepage         = "https://github.com/welbesw/BigcommerceApi"
  s.license          = 'MIT'
  s.author           = "William Welbes"
  s.source           = { :git => "https://github.com/welbesw/BigcommerceApi.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/welbes'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'BigcommerceApi' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation'
  s.dependency 'Alamofire', '~> 2.0'
end

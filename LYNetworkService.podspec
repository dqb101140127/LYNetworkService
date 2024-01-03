#
# Be sure to run `pod lib lint LYNetworkService.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LYNetworkService'
  s.version          = '0.2.0'
  s.summary          = 'A short description of LYNetworkService.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitee.com/dongluoyi/LYNetworkService'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lorry' => 'dongqiangbin@foxmail.com' }
  s.source           = { :git => 'https://gitee.com/dongluoyi/LYNetworkService.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'LYNetworkService/Classes/**/*'
  
   s.resource_bundles = {
     'LYNetworkService' => ['LYNetworkService/Assets/*.png']
   }

   s.public_header_files = 'Pod/Classes/**/*.h'
   s.dependency 'Alamofire'
   s.dependency 'SwiftyJSON'
   s.dependency 'HandyJSON'

end

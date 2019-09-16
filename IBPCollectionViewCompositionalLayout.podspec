Pod::Spec.new do |s|
  s.name                  = 'IBPCollectionViewCompositionalLayout'
  s.version               = '0.6.6'
  s.summary               = 'Backport of UICollectionViewCompositionalLayout to earlier iOS 12.'
  s.description           = <<-DESC
                              A new UICollectionViewCompositionalLayout class has been added to UIKit to make it incredibly easier to create custom complex collection view layout.
                              You can use new excellent APIs immediately without maintaining two different code bases until iOS 13 would be widely adopted.
                            DESC
  s.homepage              = "https://github.com/kishikawakatsumi/#{s.name}"
  s.ios.deployment_target = '10.0'
  s.source_files          = 'Sources/**/*.{h,m}'
  s.public_header_files   = "Sources/#{s.name}/include/*.h"
  s.frameworks            = 'UIKit'
  s.source                = { :git => "https://github.com/kishikawakatsumi/#{s.name}.git", :tag => "v#{s.version}" }
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Kishikawa Katsumi' => 'kishikawakatsumi@mac.com' }
  s.social_media_url      = 'https://twitter.com/k_katsumi'
end

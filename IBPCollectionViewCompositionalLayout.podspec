Pod::Spec.new do |s|
  s.name                  = 'IBPCollectionViewCompositionalLayout'
  s.version               = '0.3.1'
  s.summary               = 'Backport of UICollectionViewCompositionalLayout to earlier iOS 12.'
  s.description           = <<-DESC
                              A new UICollectionViewCompositionalLayout class has been added to UIKit to make it incredibly easier to create custom complex collection view layout.
                              You can use new excellent APIs immediately without maintaining two different code bases until iOS 13 would be widely adopted.
                            DESC
  s.homepage              = 'https://github.com/kishikawakatsumi/IBPCollectionViewCompositionalLayout'
  s.ios.deployment_target = '11.0'
  s.source_files          = 'IBPCollectionViewCompositionalLayout/*.{h,m}'
  s.public_header_files   = [ 'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutAnchor.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutBoundarySupplementaryItem.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutContainer_Protocol.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutDecorationItem.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutDimension.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutEdgeSpacing.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutEnvironment_Protocol.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutGroup.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutGroupCustomItem.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutItem.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutSection.h',
                              'IBPCollectionViewCompositionalLayout/IBPUICollectionLayoutSectionOrthogonalScrollingBehavior.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutSize.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutSpacing.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutSupplementaryItem.h',
                              'IBPCollectionViewCompositionalLayout/IBPNSCollectionLayoutVisibleItem.h',
                              'IBPCollectionViewCompositionalLayout/IBPUICollectionViewCompositionalLayout.h',
                              'IBPCollectionViewCompositionalLayout/IBPUICollectionViewCompositionalLayoutConfiguration.h',
                              'IBPCollectionViewCompositionalLayout/NSDirectionalEdgeInsets.h',
                              'IBPCollectionViewCompositionalLayout/NSDirectionalRectEdge.h',
                              'IBPCollectionViewCompositionalLayout/NSRectAlignment.h',
                            ]
  s.frameworks            = 'UIKit'
  s.source                = { :git => 'https://github.com/kishikawakatsumi/IBPCollectionViewCompositionalLayout.git', :tag => "v#{s.version}" }
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Kishikawa Katsumi' => 'kishikawakatsumi@mac.com' }
  s.social_media_url      = 'https://twitter.com/k_katsumi'
end

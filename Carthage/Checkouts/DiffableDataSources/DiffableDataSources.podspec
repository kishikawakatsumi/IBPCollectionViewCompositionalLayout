Pod::Spec.new do |spec|
  spec.name = 'DiffableDataSources'
  spec.version  = '0.2.0'
  spec.author = { 'ra1028' => 'r.fe51028.r@gmail.com' }
  spec.homepage = 'https://github.com/ra1028/DiffableDataSources'
  spec.documentation_url = 'https://ra1028.github.io/DiffableDataSources'
  spec.summary = 'A library for backporting UITableView/UICollectionViewDiffableDataSource.'
  spec.source = { :git => 'https://github.com/ra1028/DiffableDataSources.git', :tag => spec.version.to_s }
  spec.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  spec.requires_arc = true
  spec.source_files = 'Sources/**/*.swift'
  spec.swift_versions = ["5.0", "5.1"]

  differenekit_version = '~> 1.1'

  spec.ios.dependency 'DifferenceKit/UIKitExtension', differenekit_version
  spec.tvos.dependency 'DifferenceKit/UIKitExtension', differenekit_version
  spec.osx.dependency 'DifferenceKit/AppKitExtension', differenekit_version

  spec.ios.frameworks = 'UIKit'
  spec.tvos.frameworks = 'UIKit'
  spec.osx.frameworks = 'Appkit'

  spec.ios.deployment_target = '9.0'
  spec.tvos.deployment_target = '9.0'
  spec.osx.deployment_target = '10.11'
end

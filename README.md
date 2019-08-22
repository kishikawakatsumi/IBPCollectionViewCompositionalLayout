<p align="center">
  <img src="https://user-images.githubusercontent.com/40610/62582481-9055a980-b8e7-11e9-8c37-3a37035d8209.png"  style="width: 600px;" width="600" />
</p>

<p align="center">
  <a href="https://developer.apple.com/swift"><img alt="Languages" src="https://img.shields.io/badge/language-objective--c%20%7C%20swift-78909C.svg"/></a>
  <a href="https://github.com/kishikawakatsumi/IBPCollectionViewCompositionalLayout/releases/latest"><img alt="Release" src="https://img.shields.io/github/release/kishikawakatsumi/IBPCollectionViewCompositionalLayout.svg"/></a>
  <a href="https://cocoapods.org/pods/IBPCollectionViewCompositionalLayout"><img alt="CocoaPods" src="https://img.shields.io/cocoapods/v/IBPCollectionViewCompositionalLayout.svg"/></a>
  <a href="https://github.com/Carthage/Carthage"><img alt="Carthage" src="https://img.shields.io/badge/carthage-compatible-yellow.svg"/></a>
  <a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-ready-orange.svg"></a>
  <a href="https://github.com/kishikawakatsumi/IBPCollectionViewCompositionalLayout/blob/master/LICENSE"><img alt="MIT License" src="http://img.shields.io/badge/license-MIT-blue.svg"/></a>
</p>

----------------

## IBPCollectionViewCompositionalLayout

Backport of UICollectionViewCompositionalLayout to earlier iOS 12.

A new [UICollectionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/using_collection_view_compositional_layouts_and_diffable_data_sources) class has been added to UIKit to make it incredibly easier to create custom complex collection view layout.
You can use new excellent APIs immediately without maintaining two different code bases until iOS 13 would be widely adopted.

_Note: that this library is still currently under active development. Please file all bugs, issues, and suggestions as an Issue in the GitHub repository._

### What is Collection View Compositional Layouts?

At the WWDC 2019, Apple introduced a new form of UICollectionViewLayout. A new [UICollectionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/using_collection_view_compositional_layouts_and_diffable_data_sources) class has been added to UIKit to make it easier to create compositional layouts without requiring a custom UICollectionViewLayout.

In iOS 12 and earlier, we need subclassing of `UICollectionViewLayout` to do that. We have to override lots of methods correctly, and it is error-prone.

With Collection View Compositional Layouts, you can make very complex layout even nested collection views with independently scrolling sections just within few lines of code.

See also:

- [Advances in Collection View Layout - WWDC 2019](https://developer.apple.com/videos/play/wwdc2019/215/)
- [Using CollectionView Compositional Layouts in Swift 5](https://dev.to/kevinmaarek/using-collectionview-compositional-layouts-in-swift-5-1nan)
- [Move your cells left to right, up and down on iOS 13](https://medium.com/shopback-engineering/move-your-cells-left-to-right-up-and-down-on-ios-13-part-1-1a5e010f48f9)

### Screenshots

|Nested Group|Orthogonal Scroll|Orthogonal Scroll|
|:-:|:-:|:-:|
|![screenshot](https://user-images.githubusercontent.com/40610/62560784-c29be280-b8b8-11e9-970f-d939b2713f93.gif)|![screenshot](https://user-images.githubusercontent.com/40610/62560308-bb280980-b8b7-11e9-9bfe-c93ee1caef78.gif)|![screenshot](https://user-images.githubusercontent.com/40610/62560791-c596d300-b8b8-11e9-9c9a-4543a5a466cd.gif)|

|List|Grid|Inset Grid|Column|
|:-:|:-:|:-:|:-:|
|![screenshot](https://user-images.githubusercontent.com/40610/62560843-de06ed80-b8b8-11e9-96b1-3a1da6e9bd58.png)|![screenshot](https://user-images.githubusercontent.com/40610/62560851-e2330b00-b8b8-11e9-96f0-455aaa032931.png)|![screenshot](https://user-images.githubusercontent.com/40610/62560886-f24aea80-b8b8-11e9-9756-4919f078a7f2.png)|![screenshot](https://user-images.githubusercontent.com/40610/62560882-ef4ffa00-b8b8-11e9-8f33-5c090434492c.png)|

|Distinct Sections|Badges|Nested Groups|
|:-:|:-:|:-:|
|![screenshot](https://user-images.githubusercontent.com/40610/62560897-f545db00-b8b8-11e9-9574-55466d8ef81b.png)|![screenshot](https://user-images.githubusercontent.com/40610/62560903-f7a83500-b8b8-11e9-8766-5273db0817a8.png)|![screenshot](https://user-images.githubusercontent.com/40610/62560909-fa0a8f00-b8b8-11e9-8749-3d93e2295fdd.png)|

|Mosaic|Tile Grid|Banner Tile Grid|Portlait Tile Grid|
|:-:|:-:|:-:|:-:|
|![screenshot](https://user-images.githubusercontent.com/40610/62560914-fd057f80-b8b8-11e9-9899-8b430802941b.png)|![screenshot](https://user-images.githubusercontent.com/40610/62560917-00990680-b8b9-11e9-93bb-2d36cdbb46f9.png)|![screenshot](https://user-images.githubusercontent.com/40610/62560925-042c8d80-b8b9-11e9-8d6d-71a1290498e6.png)|![screenshot](https://user-images.githubusercontent.com/40610/62560928-068ee780-b8b9-11e9-81b1-3c9ca640c10d.png)|

## Usage

Copy `IBPCollectionViewCompositionalLayout/IBPCollectionViewCompositionalLayoutInteroperability.swift` file to your project.
It tricks the compiler to make the same code base available for iOS 13 and earlier than iOS 12.

Import `IBPCollectionViewCompositionalLayout`.

Then you can use Collection View Compositonal Layouts API as-is.

```swift
import IBPCollectionViewCompositionalLayout

let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                     heightDimension: .fractionalHeight(1))
let item = NSCollectionLayoutItem(layoutSize: itemSize)

let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                      heightDimension: .absolute(44))
let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

let section = NSCollectionLayoutSection(group: group)

let layout = UICollectionViewCompositionalLayout(section: section)

let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
...
```

### IBPCollectionViewCompositionalLayoutInteroperability.swift

This file silences the following compilation errors when building on Xcode 11 or higher environment.

```
'UICollectionViewCompositionalLayout' is only available in iOS 13.0 or newer
```

## Features

- [x] Inter Item Spacing
- [x] Inter Group Spacing  
- [x] Inter Section Spacing  
- [x] Fixed Spacing
- [x] Flexible Spacing
- [x] Nested Groups
- [x] Vertical Scrolling
- [x] Horizontal Scrolling
- [x] Supplemental Views (e.g. Section Header/Footers)
- [x] Pinned Section Header/Footers
- [x] Decoration Views (e.g. Background Views)
- [x] Orthogonal Scrolling
- [x] Orthogonal Scrolling Behavior
- [x] Estimated Size (Autosizing)
- [x] Custom Group Item (Absolute Positions)
- [x] Drop-in replacement

## TODOs (Not yet supported)

- [ ] RTL Support
- [ ] Visual Debug Description
- [ ] Performance Optimization

## Requirements

- Swift 5.0+ or Objective-C
- iOS 10.0+

## Installation

### [CocoaPods](https://cocoapods.org)

Add the following to your `Podfile`:

```ruby
pod 'IBPCollectionViewCompositionalLayout'
```

### [Carthage](https://github.com/Carthage/Carthage)

Add the following to your `Cartfile`:

```
github "kishikawakatsumi/IBPCollectionViewCompositionalLayout"
```

## Special Thanks

Thanks to [Ryo Aoyama](https://github.com/ra1028), the author of [DiffableDataSources](https://github.com/ra1028/DiffableDataSources). A backport library of Diffable Data Sources. It is used in the sample code.

Thanks to [Astemir Eleev](https://github.com/jVirus). Most of the sample code are borrowed from his [uicollectionview-layouts-kit](https://github.com/jVirus/uicollectionview-layouts-kit).

## Author
[Kishikawa Katsumi](https://github.com/kishikawakatsumi)

## Licence
The project is available under [MIT Licence](https://github.com/kishikawakatsumi/IBPCollectionViewCompositionalLayout/blob/master/LICENSE)

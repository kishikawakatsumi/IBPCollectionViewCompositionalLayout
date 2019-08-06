<H1 align="center">
DiffableDataSources
</H1>
<H4 align="center">
💾 A library for backporting UITableView/UICollectionViewDiffableDataSource</br>
powered by <a href="https://github.com/ra1028/DifferenceKit">DifferenceKit</a>.
</H4>

<p align="center">
<a href="https://developer.apple.com/swift"><img alt="Swift5" src="https://img.shields.io/badge/language-Swift5-orange.svg"/></a>
<a href="https://github.com/ra1028/DiffableDataSources/releases/latest"><img alt="Release" src="https://img.shields.io/github/release/ra1028/DiffableDataSources.svg"/></a>
<a href="https://cocoapods.org/pods/DiffableDataSources"><img alt="CocoaPods" src="https://img.shields.io/cocoapods/v/DiffableDataSources.svg"/></a>
<a href="https://github.com/Carthage/Carthage"><img alt="Carthage" src="https://img.shields.io/badge/carthage-compatible-yellow.svg"/></a>
<a href="https://swift.org/package-manager"><img alt="Swift Package Manager" src="https://img.shields.io/badge/SwiftPM-compatible-yellowgreen.svg"/></a>
</br>
<a href="https://dev.azure.com/ra1028/GitHub/_build/latest?definitionId=3&branchName=master"><img alt="Build Status" src="https://dev.azure.com/ra1028/GitHub/_apis/build/status/ra1028.DiffableDataSources?branchName=master"/></a>
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS-green.svg"/></a>
<a href="https://github.com/ra1028/DiffableDataSources/blob/master/LICENSE"><img alt="Lincense" src="https://img.shields.io/badge/License-Apache%202.0-black.svg"/></a>
</p>

<p align="center">
Made with ❤️ by <a href="https://github.com/ra1028">Ryo Aoyama</a>
</p>

---

## Introduction

<img src="https://raw.githubusercontent.com/ra1028/DiffableDataSources/master/assets/insertion_sort.gif" height="400" align="right">
<img src="https://raw.githubusercontent.com/ra1028/DiffableDataSources/master/assets/mountains.gif" height="400" align="right">

Apple has announced a diffable data source at WWDC 2019.  
It's a great API that easily updating our table view and collection view items using automatic diffing.  
However, it's a little while before we can use it in a production service.  
That because it requires the latest OS to use.  
DiffableDataSources make it possible to introduce almost the same functionality from now on.  

Uses a sophisticated open source [DifferenceKit](https://github.com/ra1028/DifferenceKit) for the algorithm engine.  
It's extremely fast and completely avoids synchronization bugs, exceptions, and crashes.  

<br clear="all">

---

## Difference from the Official

#### Spec

- Supports iOS 9.0+ / macOS 10.11+ / tvOS 9.0+
- Open sourced algorithm.
- Duplicate sections or items are allowed.  
- Using `performBatchUpdates` for diffing updates.

#### Namings

`DiffableDataSources` have different class names to avoid conflicts with the official API.  
Correspondence table is below.  

|Official                                                                    |Backported                           |
|:---------------------------------------------------------------------------|:------------------------------------|
|[NSDiffableDataSourceSnapshot][NSDiffableDataSourceSnapshot_doc]            |DiffableDataSourceSnapshot           |
|[UITableViewDiffableDataSource][UITableViewDiffableDataSource_doc]          |TableViewDiffableDataSource          |
|[UICollectionViewDiffableDataSource][UICollectionViewDiffableDataSource_doc]|CollectionViewDiffableDataSource     |
|[NSCollectionViewDiffableDataSource][NSCollectionViewDiffableDataSource_doc]|CocoaCollectionViewDiffableDataSource|

[NSDiffableDataSourceSnapshot_doc]: https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource
[UITableViewDiffableDataSource_doc]: https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource
[UICollectionViewDiffableDataSource_doc]: https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource
[NSCollectionViewDiffableDataSource_doc]: https://developer.apple.com/documentation/appkit/nscollectionviewdiffabledatasource

---

## Getting Started

- [API Documentation](https://ra1028.github.io/DiffableDataSources)
- [Example Apps](https://github.com/ra1028/DiffableDataSources/tree/master/Examples)
- [WWDC 2019 Session](https://developer.apple.com/videos/play/wwdc2019/220)

#### Build Project

```sh
$ git clone https://github.com/ra1028/DiffableDataSources.git
$ cd DiffableDataSources/
$ make setup
$ open DiffableDataSources.xcworkspace
```

---

## Basic Usage

First, define the type representing section.  
It should conforms to `Hashable` for identifies from the all sections.  
Type of enum can used conveniently befause it conforms `Hashable` by default.  

```swift
enum Section {
    case main
}
```

Then, define the item type conforms to `Hashable`.  

```swift
struct User: Hashable {
    var name: String
}
```

Create a data source object, it will be set to table view automatically.  
You should dequeue the non nil cells via closure.  

```swift
final class UsersViewController: UIViewController {
    let tableView: UITableView = ...

    lazy var dataSource = TableViewDiffableDataSource<Section, User>(tableView: tableView) { tableView, indexPath, user in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = user.name
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}
```

Manages and updates the data sources intuitively by intermediating `DiffableDataSourceSnapshot`.  
The UI isn't updated until you apply the edited snapshot object.  
Update the UI with diffing animation automatically calculated by applying an edited snapshot.  

```swift
let users = [
    User(name: "Steve Jobs"),
    User(name: "Stephen Wozniak"),
    User(name: "Tim Cook"),
    User(name: "Jonathan Ive")
]

let snapshot = DiffableDataSourceSnapshot<Section, User>()
snapshot.appendSections([.main])
snapshot.appendItems(users)

dataSource.apply(snapshot)
```

Check the documentation for more detailed API.  

<H3 align="center">
<a href="https://ra1028.github.io/DiffableDataSources">[See More Usage]</a>
</H3>

---

## Requirements

- Swift 5.0+
- iOS 9.0+
- macOS 10.11+
- tvOS 9.0+

---

## Installation

### [CocoaPods](https://cocoapods.org)
Add the following to your `Podfile`:
```ruby
pod 'DiffableDataSources'
```

### [Carthage](https://github.com/Carthage/Carthage)
Add the following to your `Cartfile`:
```
github "ra1028/DiffableDataSources"
```

### [Swift Package Manager](https://swift.org/package-manager/)
Add the following to the dependencies of your `Package.swift`:
```swift
.package(url: "https://github.com/ra1028/DiffableDataSources.git", from: "x.x.x")
```

---

## Contributing

Pull requests, bug reports and feature requests are welcome 🚀  
Please see the [CONTRIBUTING](https://github.com/ra1028/DiffableDataSources/blob/master/CONTRIBUTING.md) file for learn how to contribute to DiffableDataSources.  

---

## Relations

#### [DifferenceKit](https://github.com/ra1028/DifferenceKit)  
A fast and flexible O(n) difference algorithm framework for Swift collection.

#### [Carbon](https://github.com/ra1028/Carbon)  
A declarative library for building component-based user interfaces in UITableView and UICollectionView.

---

## License

DiffableDataSources is released under the [Apache 2.0 License](https://github.com/ra1028/DiffableDataSources/blob/master/LICENSE).  

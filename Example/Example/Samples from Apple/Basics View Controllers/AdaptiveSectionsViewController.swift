/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A layout that adapts to a changing layout environment
*/

import UIKit

class AdaptiveSectionsViewController: UIViewController {

    enum SectionLayoutKind: Int, CaseIterable {
        case list, grid5, grid3
        func columnCount(for width: CGFloat) -> Int {
            let wideMode = width > 800
            switch self {
            case .grid3:
                return wideMode ? 6 : 3

            case .grid5:
                return wideMode ? 10 : 5

            case .list:
                return wideMode ? 2 : 1
            }
        }
    }

    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Adaptive Sections"
        configureHierarchy()
        configureDataSource()
    }
}

extension AdaptiveSectionsViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let layoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }

            let columns = layoutKind.columnCount(for: layoutEnvironment.container.effectiveContentSize.width)

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let groupHeight = layoutKind == .list ?
                NSCollectionLayoutDimension.absolute(44) : NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
}

extension AdaptiveSectionsViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            let section = SectionLayoutKind(rawValue: indexPath.section)!
            if section == .list {
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ListCell.reuseIdentifier,
                    for: indexPath) as? ListCell {
                    cell.label.text = "\(identifier)"
                    return cell
                } else {
                    fatalError("Cannot create new cell")
                }
            } else {
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TextCell.reuseIdentifier,
                    for: indexPath) as? TextCell {
                    cell.label.text = "\(identifier)"
                    cell.contentView.backgroundColor = .cornflowerBlue
                    cell.contentView.layer.borderColor = UIColor.black.cgColor
                    cell.contentView.layer.borderWidth = 1
                    cell.contentView.layer.cornerRadius = section == .grid5 ? 8 : 0
                    cell.label.textAlignment = .center
                    cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
                    return cell
                } else {
                    fatalError("Cannot create new cell")
                }
            }
        }

        // initial data
        let itemsPerSection = 10
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
        SectionLayoutKind.allCases.forEach {
            snapshot.appendSections([$0])
            let itemOffset = $0.rawValue * itemsPerSection
            let itemUpperbound = itemOffset + itemsPerSection
            snapshot.appendItems(Array(itemOffset..<itemUpperbound))
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension AdaptiveSectionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

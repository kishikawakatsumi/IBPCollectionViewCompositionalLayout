//
//  CheckmarkGridViewController.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Alex Gurin on 8/27/19.
//

import UIKit

class CheckmarkGridViewController: UIViewController, UICollectionViewDelegate {
    static let checkMarkElementKind = "checkMarkElementKind"

    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collection: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Checkmark Grid"
        configureHierarchy()
        configureDataSource()
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitem: item, count: 3)
        let suppItemSize = NSCollectionLayoutSize(widthDimension: .absolute(45),
                                                  heightDimension: .absolute(45))
        let suppItemPlace = NSCollectionLayoutAnchor(edges: [.top, .trailing])
        let suppItem = NSCollectionLayoutSupplementaryItem(layoutSize: suppItemSize,
                                                           elementKind: CheckmarkGridViewController.checkMarkElementKind,
                                                           containerAnchor: suppItemPlace)
        group.supplementaryItems = [suppItem]

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func configureHierarchy() {
        collection = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.backgroundColor = .systemBackground
        collection.register(UINib(nibName: "ListCell2", bundle: nil), forCellWithReuseIdentifier: ListCell2.reuseIdentifier)
        collection.register(UINib(nibName: "CheckmarkView", bundle: nil),
                            forSupplementaryViewOfKind: CheckmarkGridViewController.checkMarkElementKind,
                            withReuseIdentifier: CheckmarkView.reuseIdentifier)
        collection.delegate = self
        view.addSubview(collection)
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collection) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in

            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCell2.reuseIdentifier,
                for: indexPath) as? ListCell2 else { fatalError("Cannot create new cell") }

            // Populate the cell with our item description.
            cell.configureWith(text: "\(indexPath.row)", image: nil)

            // Return the cell.
            return cell
        }

        dataSource.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            // Get a supplementary view of the desired kind.
            if let badgeView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CheckmarkView.reuseIdentifier,
                for: indexPath) as? CheckmarkView {

                // Return the view.
                return badgeView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(1..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

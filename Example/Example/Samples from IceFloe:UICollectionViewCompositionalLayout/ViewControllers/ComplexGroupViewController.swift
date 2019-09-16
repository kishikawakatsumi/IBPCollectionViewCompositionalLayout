//
//  ComplexGroupViewController.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Alex Gurin on 8/26/19.
//

import UIKit

class ComplexGroupViewController: UIViewController, UICollectionViewDelegate {

    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collection: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Complex Group"
        configureHierarchy()
        configureDataSource()
    }

    private func createLayout() -> UICollectionViewLayout {
        let verticalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(0.3))
        let verticalItem = NSCollectionLayoutItem(layoutSize: verticalItemSize)

        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                       heightDimension: .fractionalHeight(1))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize,
                                                             subitem: verticalItem, count: 3)
        verticalGroup.interItemSpacing = .fixed(8)
        // ---------------------------------------------------------------------------------
        let horizontalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                      heightDimension: .fractionalHeight(1))
        let horizontalItem = NSCollectionLayoutItem(layoutSize: horizontalItemSize)
        let horizontalItemSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                      heightDimension: .fractionalHeight(1))
        let horizontalItem2 = NSCollectionLayoutItem(layoutSize: horizontalItemSize2)

        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .fractionalHeight(0.3))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize,
                                                             subitems: [horizontalItem, horizontalItem2, horizontalItem])
        let horizontalGroup2 = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize,
                                                                  subitems: [horizontalItem2, horizontalItem, horizontalItem])
        let horizontalGroup3 = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize,
                                                                  subitems: [horizontalItem, horizontalItem, horizontalItem2])
        horizontalGroup.interItemSpacing = .fixed(8)
        horizontalGroup2.interItemSpacing = .fixed(8)
        horizontalGroup3.interItemSpacing = .fixed(8)
        // ---------------------------------------------------------------------------------
        let horizontalsGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75),
                                                       heightDimension: .fractionalHeight(1))
        let horizontalsGroup = NSCollectionLayoutGroup.vertical(layoutSize: horizontalsGroupSize,
                                                             subitems: [horizontalGroup, horizontalGroup2, horizontalGroup3])
        horizontalsGroup.interItemSpacing = .flexible(0)
        // ---------------------------------------------------------------------------------

        let finalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalHeight(0.5))
        let finalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: finalGroupSize,
                                                            subitems: [horizontalsGroup, verticalGroup])

        let section = NSCollectionLayoutSection(group: finalGroup)
        section.interGroupSpacing = 8

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func configureHierarchy() {
        collection = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.backgroundColor = .systemBackground
        collection.register(UINib(nibName: "ListCell2", bundle: nil), forCellWithReuseIdentifier: ListCell2.reuseIdentifier)
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

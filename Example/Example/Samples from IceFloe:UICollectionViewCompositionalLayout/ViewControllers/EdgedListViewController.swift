//
//  EdgedListViewController.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Alex Gurin on 8/26/19.
//

import UIKit

class EdgedListViewController: UIViewController , UICollectionViewDelegate {

    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collection: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edged List"
        configureHierarchy()
        configureDataSource()
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .flexible(0), top: nil,
                                                         trailing: .flexible(16), bottom: nil)
        let itemSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                              heightDimension: .fractionalHeight(1))
        let item2 = NSCollectionLayoutItem(layoutSize: itemSize2)
        item2.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil,
                                                          trailing: .flexible(0), bottom: nil)


        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item, item2])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10

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

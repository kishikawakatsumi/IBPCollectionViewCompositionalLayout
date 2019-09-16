//
//  BackgroundViewController.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Alex Gurin on 8/28/19.
//

import UIKit

class BackgroundViewController: UIViewController, UICollectionViewDelegate {

    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collection: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Background Section"
        configureHierarchy()
        configureDataSource()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collection.collectionViewLayout.invalidateLayout()
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .flexible(0), top: nil, trailing: nil, bottom: nil)

        let background = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        background.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [background]
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(BackgroundView.self, forDecorationViewOfKind: "background")

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
        snapshot.appendItems(Array(1..<6))
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//
//  TileGridViewController.swift
//  compositional-layouts-kit
//
//  Created by Astemir Eleev on 22/06/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit
import DiffableDataSources
import IBPCollectionViewCompositionalLayout

class TileGridViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ImageModel>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tile Grid Layout"
        configureHierarchy()
        configureDataSource()
    }
}

extension TileGridViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in


            let centerItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.666)))
            centerItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.333)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 3)

            let centerTopItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)))
            centerTopItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            let centerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                    heightDimension: .fractionalHeight(0.333)),
                                                                 subitem: centerTopItem, count: 2)
            let centerMegaGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                                                      heightDimension: .fractionalHeight(1.0)),
                                                                     subitems: [centerGroup, centerItem])

            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.5)),
                subitems: [trailingGroup, centerMegaGroup, trailingGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)

            return section
        }
        return layout
    }
}

extension TileGridViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ImageModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, model: ImageModel) -> UICollectionViewCell? in
            
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCell.reuseIdentifier,
                for: indexPath) as? ImageCell else { fatalError("Could not create new cell") }
            cell.image = ImageFactory.produce(using: .random)
            cell.imageContentMode = .scaleAspectFill
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            
            return cell
        }
        
        // Initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, ImageModel>()
        snapshot.appendSections([.main])
        
        func produceImage() -> UIImage {
            guard let image = ImageFactory.produce(using: .random) else {
                fatalError("Could not generate an UIImage instance by using the ImageFactory struct")
            }
            return image
        }
        
        let models = (0..<100).map { _ in ImageModel(image: produceImage()) }
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

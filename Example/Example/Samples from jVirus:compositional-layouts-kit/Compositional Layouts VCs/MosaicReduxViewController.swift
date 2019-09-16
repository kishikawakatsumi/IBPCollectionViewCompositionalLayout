//
//  MosaicReduxViewController.swift
//  compositional-layouts-kit
//
//  Created by Astemir Eleev on 22/06/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit
import DiffableDataSources
import IBPCollectionViewCompositionalLayout

class MosaicReduxViewController: UIViewController {
    
    var layoutFractionalConfig: LayoutFractionalConfiguration = .small
    
    enum LayoutFractionalConfiguration: CGFloat {
        case small = 1.0
        case big = 2.0
    }
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ImageModel>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mosaic Redux Layout"
        configureHierarchy()
        configureDataSource()
    }
}

extension MosaicReduxViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
            let smallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                      heightDimension: .fractionalHeight(1.0)))
            smallItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let smallItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                       heightDimension: .fractionalHeight(0.5)),
                                                                    subitem: smallItem, count: 2)
            
            let smallItemMegaGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                                                         heightDimension: .fractionalHeight(1.0)),
                                                                      subitem: smallItemGroup, count: 2)
            
            
            let bigItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                    heightDimension: .fractionalHeight(1.0)))
            bigItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            let bigItemGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                                                   heightDimension: .fractionalHeight(1.0)),
                                                                subitem: bigItem, count: 1)
            
            let topMegaGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                     heightDimension: .fractionalHeight(0.5)),
                                                                  subitems: [bigItemGroup, smallItemMegaGroup])
            let bottomMegaGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                        heightDimension: .fractionalHeight(0.5)),
                                                                     subitems: [smallItemMegaGroup, bigItemGroup])
            
            let gigaGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(self.layoutFractionalConfig.rawValue),
                                                                                                heightDimension: .fractionalHeight(1.0)),
                                                             subitems: [topMegaGroup, bottomMegaGroup])
            
            let section = NSCollectionLayoutSection(group: gigaGroup)
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        layout.configuration = config
        
        return layout
    }
}

extension MosaicReduxViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.isDirectionalLockEnabled = true
        collectionView.alwaysBounceVertical = false
        collectionView.contentInsetAdjustmentBehavior = .never
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

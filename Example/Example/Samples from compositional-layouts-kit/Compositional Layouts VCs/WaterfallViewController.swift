//
//  WaterfallViewController.swift
//  compositional-layouts-kit
//
//  Created by Astemir Eleev on 19/06/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit
import DiffableDataSources
import IBPCollectionViewCompositionalLayout

class WaterfallViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ImageModel>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Waterfall Layout"
        configureHierarchy()
        configureDataSource()
    }
}

extension WaterfallViewController {
    private func createLayout() -> UICollectionViewLayout {
        let topLeftItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.55))
        let topLeftItem = NSCollectionLayoutItem(layoutSize: topLeftItemSize)
        topLeftItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let topLeftBottomItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(0.45))
        let topLeftBottomItem = NSCollectionLayoutItem(layoutSize: topLeftBottomItemSize)
        topLeftBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        topLeftBottomItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(-24))

        
        let topMidItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.4))
        let topMidItem = NSCollectionLayoutItem(layoutSize: topMidItemSize)
        topMidItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        topMidItem.edgeSpacing = .init(leading: .none, top: .fixed(24), trailing: .none, bottom: .none)
        
        let topMidBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                         heightDimension: .fractionalHeight(0.6)))
        topMidBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        topMidBottomItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(-24))
        
        let topRightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalHeight(0.65))
        let topRightItem = NSCollectionLayoutItem(layoutSize: topRightItemSize)
        topRightItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let topRightBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                           heightDimension: .fractionalHeight(0.35)))
        topRightBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        topRightBottomItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(-24))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        
        let leftGroup = NSCollectionLayoutGroup.vertical(layoutSize:
            NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(0.33),
                                        heightDimension: .fractionalHeight(1.0)),
                                                         subitems: [topLeftItem, topLeftBottomItem])
        
        let midGroup = NSCollectionLayoutGroup.vertical(layoutSize:
            NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(0.33),
                                        heightDimension: .fractionalHeight(1.0)),
                                                         subitems: [topMidItem, topMidBottomItem])
        
        let rightGroup = NSCollectionLayoutGroup.vertical(layoutSize:
            NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(0.33),
                                        heightDimension: .fractionalHeight(1.0)),
                                                        subitems: [topRightItem, topRightBottomItem])
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftGroup, midGroup, rightGroup])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension WaterfallViewController {
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
            cell.image = model.image
            cell.imageContentMode = .scaleAspectFill
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]

            return cell
        }
        
        // initial data
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

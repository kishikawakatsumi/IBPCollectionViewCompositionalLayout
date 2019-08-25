//
//  ShowcaseGalleryViewController.swift
//  compositional-layouts-kit
//
//  Created by Astemir Eleev on 23/06/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit
import DiffableDataSources
import IBPCollectionViewCompositionalLayout

class ShowcaseGalleryViewController: UIViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, ImageModel>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Showcase Gallery Layout"
        configureHierarchy()
        configureDataSource()
    }
}

extension ShowcaseGalleryViewController {
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
            
            let galleryItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                        heightDimension: .fractionalHeight(1.0)))
            galleryItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)

            if sectionIndex % 2 == 0 {
                let galleryGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                                                                                         heightDimension: .fractionalHeight(0.75)),
                                                                  subitem: galleryItem, count: 1)
                
                let gallerySection = NSCollectionLayoutSection(group: galleryGroup)
                gallerySection.orthogonalScrollingBehavior = .groupPagingCentered
                return gallerySection
            } else {
                
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0),
                                                                                                                 heightDimension: .fractionalHeight(0.25)), subitem: galleryItem, count: 4)
                let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(0.25),
                                                                                                             heightDimension: .fractionalHeight(1.0)), subitem: galleryItem, count: 3)
                let centerGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(0.75),
                                                                                                           heightDimension: .fractionalHeight(1.0)), subitem: galleryItem, count: 1)
                let showcaseSubGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0),
                                                                                                                  heightDimension: .fractionalHeight(0.75)), subitems: [verticalGroup, centerGroup])
                let showcaseMegagroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0),
                                                                                                                 heightDimension: .fractionalHeight(0.8)),
                                                                         subitems: [horizontalGroup, showcaseSubGroup])
                
                let showcaseSection = NSCollectionLayoutSection(group: showcaseMegagroup)
                return showcaseSection
            }
        }
        return layout
    }
}

extension ShowcaseGalleryViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, ImageModel>(collectionView: collectionView) {
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
        
        func produceImage() -> UIImage {
            guard let image = ImageFactory.produce(using: .random) else {
                fatalError("Could not generate an UIImage instance by using the ImageFactory struct")
            }
            return image
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageModel>()
        var identifierOffset = 0
        let itemsPerSection = 8
        for section in 0..<8 {
            snapshot.appendSections([section])
            let maxIdentifier = identifierOffset + itemsPerSection
            let models = (0..<maxIdentifier).map { _ in ImageModel(image: produceImage()) }
            snapshot.appendItems(models)
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


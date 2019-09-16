//
//  HeaderFooterViewController.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Alex Gurin on 8/28/19.
//

import UIKit

class HeaderFooterViewController: UIViewController, UICollectionViewDelegate {
    static let footerKind = "footerKind"
    static let headerKind = "headerKind"
    static let leadingKind = "leadingKind"

    enum Section {
        case first
        case second
        case third
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collection: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Header & Footer"
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                              heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .flexible(0), top: nil, trailing: nil, bottom: nil)

        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(50.0))
        let leftSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.1),
                                              heightDimension: .absolute(150.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize,
                                                                 elementKind: HeaderFooterViewController.headerKind,
                                                                 alignment: .top)
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize,
                                                                 elementKind: HeaderFooterViewController.footerKind,
                                                                 alignment: .bottom)
        let left = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: leftSize,
                                                               elementKind: HeaderFooterViewController.leadingKind,
                                                               alignment: .leading)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header, footer, left]

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)

        return layout
    }

    private func configureHierarchy() {
        collection = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.backgroundColor = .systemBackground
        collection.register(UINib(nibName: "ListCell2", bundle: nil), forCellWithReuseIdentifier: ListCell2.reuseIdentifier)
        collection.register(UINib(nibName: "TitleView", bundle: nil),
                            forSupplementaryViewOfKind: HeaderFooterViewController.headerKind,
                            withReuseIdentifier: TitleView.reuseIdentifier)
        collection.register(UINib(nibName: "TitleView", bundle: nil),
                            forSupplementaryViewOfKind: HeaderFooterViewController.footerKind,
                            withReuseIdentifier: TitleView.reuseIdentifier)
        collection.register(UINib(nibName: "TitleView", bundle: nil),
                            forSupplementaryViewOfKind: HeaderFooterViewController.leadingKind,
                            withReuseIdentifier: TitleView.reuseIdentifier)
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
            if let titleView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleView.reuseIdentifier,
                for: indexPath) as? TitleView {

                switch kind {
                case HeaderFooterViewController.footerKind:
                    titleView.titleLbl.text = "Footer"
                case HeaderFooterViewController.headerKind:
                    titleView.titleLbl.text = "Header"
                case HeaderFooterViewController.leadingKind:
                    titleView.titleLbl.text = "Leading"
                default:
                    ()
                }
                return titleView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.first])
        snapshot.appendItems(Array(1..<6))
        snapshot.appendSections([.second])
        snapshot.appendItems(Array(6..<10))
        snapshot.appendSections([.third])
        snapshot.appendItems(Array(10..<15))
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

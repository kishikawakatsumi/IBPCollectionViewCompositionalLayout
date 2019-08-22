/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Pinned sction headers example
*/

import UIKit

class PinnedSectionHeaderFooterViewController: UIViewController {

    static let sectionHeaderElementKind = "section-header-element-kind"
    static let sectionFooterElementKind = "section-footer-element-kind"

    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pinned Section Headers"
        configureHierarchy()
        configureDataSource()
    }
}

extension PinnedSectionHeaderFooterViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44)),
            elementKind: PinnedSectionHeaderFooterViewController.sectionHeaderElementKind,
            alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44)),
            elementKind: PinnedSectionHeaderFooterViewController.sectionFooterElementKind,
            alignment: .bottom)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension PinnedSectionHeaderFooterViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self,
                    forSupplementaryViewOfKind: PinnedSectionHeaderFooterViewController.sectionHeaderElementKind,
                    withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self,
                    forSupplementaryViewOfKind: PinnedSectionHeaderFooterViewController.sectionFooterElementKind,
                    withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in

            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCell.reuseIdentifier,
                for: indexPath) as? ListCell else { fatalError("Cannot create new cell") }

            // Populate the cell with our item description.
            cell.label.text = "\(indexPath.section),\(indexPath.item)"

            // Return the cell.
            return cell
        }
        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in

            // Get a supplementary view of the desired kind.
            guard let headerFooter = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleSupplementaryView.reuseIdentifier,
                for: indexPath) as? TitleSupplementaryView else { fatalError("Cannot create new header") }

            // Populate the view with our section's description.
            let viewKind = kind == PinnedSectionHeaderFooterViewController.sectionHeaderElementKind ?
                "Header" : "Footer"
            headerFooter.label.text = "\(viewKind) for section \(indexPath.section)"
            headerFooter.backgroundColor = .lightGray
            headerFooter.layer.borderColor = UIColor.black.cgColor
            headerFooter.layer.borderWidth = 1.0

            // Return the view.
            return headerFooter
        }

        // initial data
        let itemsPerSection = 5
        let sections = Array(0..<5)
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var itemOffset = 0
        sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems(Array(itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension PinnedSectionHeaderFooterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

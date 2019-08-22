/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Sample showing how we might build the videos sessions UI
*/

import UIKit

class ConferenceVideoSessionsViewController: UIViewController {

    let videosController = ConferenceVideoController()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource
        <ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot
        <ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>! = nil
    static let titleElementKind = "title-element-kind"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Conference Videos"
        configureHierarchy()
        configureDataSource()
    }
}

extension ConferenceVideoSessionsViewController {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // if we have the space, adapt and go 2-up + peeking 3rd item
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                  heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: ConferenceVideoSessionsViewController.titleElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}

extension ConferenceVideoSessionsViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        collectionView.register(
            ConferenceVideoCell.self,
            forCellWithReuseIdentifier: ConferenceVideoCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self,
                                forSupplementaryViewOfKind: ConferenceVideoSessionsViewController.titleElementKind,
                                withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <ConferenceVideoController.VideoCollection,
            ConferenceVideoController.Video> (collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath,
                video: ConferenceVideoController.Video) -> UICollectionViewCell? in

            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ConferenceVideoCell.reuseIdentifier,
                for: indexPath) as? ConferenceVideoCell
                else {
                    fatalError("Cannot create new cell")
                }
            // Populate the cell with our item description.
            cell.titleLabel.text = video.title
            cell.categoryLabel.text = video.category

            // Return the cell.
            return cell
        }
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self, let snapshot = self.currentSnapshot else { return nil }

            // Get a supplementary view of the desired kind.
            if let titleSupplementary = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleSupplementaryView.reuseIdentifier,
                for: indexPath) as? TitleSupplementaryView {

                // Populate the view with our section's description.
                let videoCategory = snapshot.sectionIdentifiers[indexPath.section]
                titleSupplementary.label.text = videoCategory.title

                // Return the view.
                return titleSupplementary
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        currentSnapshot = NSDiffableDataSourceSnapshot
            <ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>()
        videosController.collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.videos)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

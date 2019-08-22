/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Shows how to use NSCollectionLayoutSupplementaryItems to badge items
*/

import UIKit

class ItemBadgeSupplementaryViewController: UIViewController {

    static let badgeElementKind = "badge-element-kind"
    enum Section {
        case main
    }

    struct Model: Hashable {
        let title: String
        let badgeCount: Int

        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Model>! = nil

    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Item Badges"
        configureHierarchy()
        configureDataSource()
    }
}

extension ItemBadgeSupplementaryViewController {
    func createLayout() -> UICollectionViewLayout {
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
                                              heightDimension: .absolute(20))
        let badge = NSCollectionLayoutSupplementaryItem(
            layoutSize: badgeSize,
            elementKind: ItemBadgeSupplementaryViewController.badgeElementKind,
            containerAnchor: badgeAnchor)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ItemBadgeSupplementaryViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        collectionView.register(BadgeSupplementaryView.self,
                    forSupplementaryViewOfKind: ItemBadgeSupplementaryViewController.badgeElementKind,
                    withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)
        view.addSubview(collectionView)
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Model>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, model: Model) -> UICollectionViewCell? in

            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TextCell.reuseIdentifier,
                for: indexPath) as? TextCell else { fatalError("Cannot create new cell") }

            // Populate the cell with our item description.
            cell.label.text = model.title
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)

            // Return the cell.
            return cell
        }
        dataSource.supplementaryViewProvider = {
            [weak self] (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            guard let self = self, let model = self.dataSource.itemIdentifier(for: indexPath) else { return nil }
            let hasBadgeCount = model.badgeCount > 0

            // Get a supplementary view of the desired kind.
            if let badgeView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier,
                for: indexPath) as? BadgeSupplementaryView {

                // Set the badge count as its label (and hide the view if the badge count is zero).
                badgeView.label.text = "\(model.badgeCount)"
                badgeView.isHidden = !hasBadgeCount

                // Return the view.
                return badgeView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.main])
        let models = (0..<100).map { Model(title: "\($0)", badgeCount: Int.random(in: 0..<3)) }
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension UIColor {
    static var cornflowerBlue: UIColor {
        return UIColor(displayP3Red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
}

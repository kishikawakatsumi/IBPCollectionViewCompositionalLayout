//
//  EstimatedListViewController.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Alex Gurin on 8/25/19.
//

import UIKit

class EstimatedListViewController: UIViewController, UICollectionViewDelegate {

    enum Section {
        case main
    }

    struct EstimatedItem: Hashable {
        let text: String
        let image: UIImage?
    }
    var data: [EstimatedItem] = [
        EstimatedItem(text: "Maecenas id erat non metus viverra semper efficitur in mauris. Morbi varius mi ex, vel mattis odio vehicula sit amet. Vestibulum non nisi bibendum", image: UIImage(named: "cat")),
        EstimatedItem(text: "", image: UIImage(named: "cat")),
        EstimatedItem(text: "Vestibulum sit amet urna eu odio vestibulum gravida. Integer finibus tellus eget lacus malesuada, eu viverra risus interdum. Curabitur dignissim ullamcorper augue, aliquam consectetur lectus tristique et. Sed sed ipsum eleifend, varius erat ut, aliquam urna. Phasellus at convallis lorem. Nulla bibendum id magna et volutpat. Suspendisse potenti. Nulla pharetra imperdiet lorem, a commodo ipsum semper at. Maecenas pretium scelerisque nunc at accumsan. Integer gravida, massa non aliquet fringilla, justo nulla molestie mi, id pulvinar turpis lorem eu lorem.", image: nil),
        EstimatedItem(text: "Ut dapibus, ligula et elementum cursus, lorem sapien rhoncus nunc, nec bibendum massa sapien sed neque. Cras sit amet ex erat. Suspendisse facilisis semper libero, a placerat orci molestie non. Donec pretium est ut pulvinar porttitor. Vivamus in tristique tellus. Phasellus ac sem ipsum. Morbi sit amet mollis nisi. Nulla facilisi.", image: nil),
        EstimatedItem(text: "Nulla bibendum maximus velit, blandit fermentum purus. Sed dapibus condimentum purus quis varius. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed auctor lobortis lectus a blandit. Nulla facilisi. Etiam sit amet orci molestie diam accumsan auctor", image: nil)
    ]

    var dataSource: UICollectionViewDiffableDataSource<Section, EstimatedItem>! = nil
    var collection: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Estimated List"
        configureHierarchy()
        configureDataSource()
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(8), trailing: nil, bottom: .fixed(8))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

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
        dataSource = UICollectionViewDiffableDataSource<Section, EstimatedItem>(collectionView: collection) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: EstimatedItem) -> UICollectionViewCell? in

            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCell2.reuseIdentifier,
                for: indexPath) as? ListCell2 else { fatalError("Cannot create new cell") }

            // Populate the cell with our item description.
            cell.configureWith(text: item.text, image: item.image)

            // Return the cell.
            return cell
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, EstimatedItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

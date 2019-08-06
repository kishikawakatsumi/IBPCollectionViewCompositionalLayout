import UIKit
import DiffableDataSources

final class MountainsViewController: UIViewController {
    enum Section {
        case main
    }

    struct Mountain: Hashable {
        var name: String

        func contains(_ filter: String) -> Bool {
            guard !filter.isEmpty else {
                return true
            }

            let lowercasedFilter = filter.lowercased()
            return name.lowercased().contains(lowercasedFilter)
        }
    }

    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var collectionView: UICollectionView!

    private lazy var dataSource = CollectionViewDiffableDataSource<Section, Mountain>(collectionView: collectionView) { collectionView, indexPath, mountain in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCell.name, for: indexPath) as! LabelCell
        cell.label.text = mountain.name
        return cell
    }

    private let allMountains: [Mountain] = mountainsRawData.components(separatedBy: .newlines).map { line in
        let name = line.components(separatedBy: ",")[0]
        return Mountain(name: name)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Mountains Search"

        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: LabelCell.name, bundle: .main), forCellWithReuseIdentifier: LabelCell.name)

        search(filter: "")
    }

    func search(filter: String) {
        let mountains = allMountains.lazy
            .filter { $0.contains(filter) }
            .sorted { $0.name < $1.name }

        let snapshot = DiffableDataSourceSnapshot<Section, Mountain>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mountains)
        dataSource.apply(snapshot)
    }
}

extension MountainsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(filter: searchText)
    }
}

extension MountainsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let column = 2
        let width = (collectionView.bounds.width - 10 * CGFloat(column + 1)) / CGFloat(column)
        return CGSize(width: width, height: 32)
    }
}

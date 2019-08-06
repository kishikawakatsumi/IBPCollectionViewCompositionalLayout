import AppKit
import DiffableDataSources

final class MountainsViewController: NSViewController {
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

    @IBOutlet private var searchField: NSSearchField!
    @IBOutlet private var collectionView: NSCollectionView!

    private lazy var dataSource = CocoaCollectionViewDiffableDataSource<Section, Mountain>(collectionView: collectionView) { collectionView, indexPath, mountain in
        let item = collectionView.makeItem(withIdentifier: LabelItem.itemIdentifier, for: indexPath) as! LabelItem
        item.label.stringValue = mountain.name
        return item
    }

    private let allMountains: [Mountain] = mountainsRawData.components(separatedBy: .newlines).map { line in
        let name = line.components(separatedBy: ",")[0]
        return Mountain(name: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Mountains Search"

        collectionView.delegate = self
        collectionView.register(LabelItem.self, forItemWithIdentifier: LabelItem.itemIdentifier)

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

    @IBAction func searchFieldDidChangeText(_ sender: NSSearchField) {
        search(filter: sender.stringValue)
    }
}

extension MountainsViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        let column = 3
        let width = (collectionView.bounds.width - 10 * CGFloat(column + 1)) / CGFloat(column)
        return CGSize(width: width, height: 44)
    }
}

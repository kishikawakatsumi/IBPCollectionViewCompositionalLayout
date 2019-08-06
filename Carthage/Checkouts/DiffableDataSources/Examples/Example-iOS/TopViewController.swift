import UIKit
import DiffableDataSources

final class TopViewController: UIViewController {
    enum Section {
        case main
    }

    enum Item {
        case mountains
        case insertionSort
    }

    @IBOutlet private var tableView: UITableView!

    private lazy var dataSource = TableViewDiffableDataSource<Section, Item>(tableView: tableView) { tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.name, for: indexPath)
        cell.textLabel?.text = item.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "DiffableDataSources"

        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.name)
        tableView.rowHeight = 60
        tableView.contentInset.top = 30

        reset()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func reset() {
        let snapshot = DiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.mountains, .insertionSort])
        dataSource.apply(snapshot)
    }
}

extension TopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        let viewController: UIViewController

        switch item {
        case .mountains:
            viewController = MountainsViewController()

        case .insertionSort:
            viewController = InsertionSortViewController()
        }

        navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension TopViewController.Item {
    var title: String {
        switch self {
        case .mountains:
            return "🗻 Mountains"

        case .insertionSort:
            return "📱 Insertion Sort"
        }
    }
}

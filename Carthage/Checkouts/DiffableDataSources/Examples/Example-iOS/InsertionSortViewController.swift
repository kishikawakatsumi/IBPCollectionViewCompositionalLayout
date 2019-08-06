import UIKit
import DiffableDataSources

final class InsertionSortViewController: UIViewController {
    final class Section: Hashable {
        var id = UUID()
        var nodes: [Node]
        private(set) var isSorted = false
        private var currentIndex = 1

        init(count: Int) {
            nodes = (0..<count).map { Node(value: $0, maxValue: count) }.shuffled()
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        func sortNext() {
            guard !isSorted, nodes.count > 1 else {
                return isSorted = true
            }

            var index = currentIndex
            let currentNode = nodes[index]
            index -= 1

            while index >= 0 && currentNode.value < nodes[index].value {
                let node = nodes[index]
                nodes[index] = currentNode
                nodes[index + 1] = node
                index -= 1
            }

            currentIndex += 1

            if currentIndex >= nodes.count {
                isSorted = true
            }
        }

        static func == (lhs: Section, rhs: Section) -> Bool {
            return lhs.id == rhs.id
        }
    }

    struct Node: Hashable {
        var id = UUID()
        var value: Int
        var color: UIColor

        init(value: Int, maxValue: Int) {
            let hue = CGFloat(value) / CGFloat(maxValue)
            self.value = value
            color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
            id = UUID()
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Node, rhs: Node) -> Bool {
            return lhs.id == rhs.id
        }
    }

    @IBOutlet private var collectionView: UICollectionView!
    private var isSorting = false

    let nodeSize = CGSize(width: 16, height: 34)

    private lazy var dataSource = CollectionViewDiffableDataSource<Section, Node>(collectionView: collectionView) { collectionView, indexPath, node in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.name, for: indexPath)
        cell.backgroundColor = node.color
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Insertion Sort"

        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.name)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(toggleSort))

        updateSortButtonTitle()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        randmize(animated: false)
    }

    @objc func toggleSort() {
        isSorting.toggle()
        updateSortButtonTitle()

        if isSorting {
            startInsertionSort()
        }
    }

    func updateSortButtonTitle() {
        navigationItem.rightBarButtonItem?.title = isSorting ? "Stop" : "Sort"
    }

    func randmize(animated: Bool) {
        let snapshot = DiffableDataSourceSnapshot<Section, Node>()
        let rows = Int(collectionView.bounds.height / nodeSize.height) - 1
        let columns = Int(collectionView.bounds.width / nodeSize.width)

        for _ in 0..<rows {
            let section = Section(count: columns)
            snapshot.appendSections([section])
            snapshot.appendItems(section.nodes)
        }

        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    func startInsertionSort() {
        guard isSorting else {
            return
        }

        var isNextSortRequired = false
        let snapshot = dataSource.snapshot()

        for section in snapshot.sectionIdentifiers where !section.isSorted {
            section.sortNext()
            let items = section.nodes
            snapshot.deleteItems(items)
            snapshot.appendItems(items, toSection: section)
            isNextSortRequired = true
        }

        if isNextSortRequired {
            dataSource.apply(snapshot)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(isNextSortRequired ? 150 : 1000)) { [weak self] in
            guard let self = self else {
                return
            }

            if !isNextSortRequired {
                self.randmize(animated: false)
            }
            self.startInsertionSort()
        }
    }
}

extension InsertionSortViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return nodeSize
    }
}

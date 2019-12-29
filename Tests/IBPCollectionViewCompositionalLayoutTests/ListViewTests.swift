import XCTest
import IBPCollectionViewCompositionalLayout

class ListViewTests: XCTestCase {
    func testViewController() {
        let viewController = ListViewController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0))

        let collectionView = viewController.collectionView!

        if #available(iOS 11.0, *) {
            let safeAreaInsets = viewController.view.safeAreaInsets

            XCTAssertEqual(collectionView.adjustedContentInset, safeAreaInsets)
            XCTAssertEqual(collectionView.contentOffset, CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top))
            XCTAssertEqual(collectionView.contentSize, CGSize(width: window.bounds.width, height: 44 * 94))
        } else {

        }
    }

    func testNavigationController() {
        let viewController = ListViewController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0))

        let collectionView = viewController.collectionView!

        if #available(iOS 11.0, *) {
            let safeAreaInsets = viewController.view.safeAreaInsets

            XCTAssertEqual(collectionView.adjustedContentInset, safeAreaInsets)
            XCTAssertEqual(collectionView.contentOffset, CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top))
            XCTAssertEqual(collectionView.contentSize, CGSize(width: window.bounds.width, height: 44 * 94))
        } else {

        }
    }

    func testTabBarController() {
        let viewController = ListViewController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [viewController]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0))

        let collectionView = viewController.collectionView!

        if #available(iOS 11.0, *) {
            let safeAreaInsets = viewController.view.safeAreaInsets

            XCTAssertEqual(collectionView.adjustedContentInset, safeAreaInsets)
            XCTAssertEqual(collectionView.contentOffset, CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top))
            XCTAssertEqual(collectionView.contentSize, CGSize(width: window.bounds.width, height: 44 * 94))
        } else {

        }
    }

    func testNavigationControllerInTabBarController() {
        let viewController = ListViewController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: viewController)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0))

        let collectionView = viewController.collectionView!

        if #available(iOS 11.0, *) {
            let safeAreaInsets = viewController.view.safeAreaInsets

            XCTAssertEqual(collectionView.adjustedContentInset, safeAreaInsets)
            XCTAssertEqual(collectionView.contentOffset, CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top))
            XCTAssertEqual(collectionView.contentSize, CGSize(width: window.bounds.width, height: 44 * 94))
        } else {

        }
    }
}

class ListViewController: UIViewController {
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureHierarchy()
        configureDataSource()
    }
}

extension ListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ListViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { (collectionView, indexPath, identifier) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.reuseIdentifier, for: indexPath) as? ListCell else { fatalError("Cannot create new cell") }
            cell.label.text = "\(identifier)"
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

class ListCell: UICollectionViewCell {
    static let reuseIdentifier = "list-cell-reuse-identifier"
    let label = UILabel()
    let accessoryImageView = UIImageView()
    let seperatorView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension ListCell {
    func configure() {
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = .lightGray
        contentView.addSubview(seperatorView)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        contentView.addSubview(label)

        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(accessoryImageView)

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)

        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let chevronImageName = rtl ? "chevron.left" : "chevron.right"
        let chevronImage = UIImage(systemName: chevronImageName)
        accessoryImageView.image = chevronImage
        accessoryImageView.tintColor = UIColor.lightGray.withAlphaComponent(0.7)

        let inset: CGFloat = 10
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            label.trailingAnchor.constraint(equalTo: accessoryImageView.leadingAnchor, constant: -inset),

            accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 13),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 20),
            accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),

            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}

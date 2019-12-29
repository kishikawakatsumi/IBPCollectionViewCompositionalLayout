import XCTest
import IBPCollectionViewCompositionalLayout

class GridViewTests: XCTestCase {
    func testViewController() {
        let viewController = GridViewController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0))

        let collectionView = viewController.collectionView!
        let fractionalWidth: CGFloat = 0.2
        let numberOfColumns: CGFloat = floor(1 / fractionalWidth)
        let width: CGFloat = window.bounds.width * fractionalWidth
        let height = width
        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        if #available(iOS 11.0, *) {
            let safeAreaInsets = viewController.view.safeAreaInsets

            XCTAssertEqual(collectionView.adjustedContentInset, safeAreaInsets)
            XCTAssertEqual(collectionView.contentOffset, CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top))
            XCTAssertEqual(collectionView.contentSize, CGSize(width: window.bounds.width, height: ceil(CGFloat(numberOfItems) / numberOfColumns) * window.bounds.width * fractionalWidth))

            for case (let index, let cell as UICollectionViewCell) in collectionView.subviews.enumerated() {
                XCTAssertEqual(cell.frame, CGRect(x: width * (CGFloat(index).truncatingRemainder(dividingBy: numberOfColumns)), y: height * floor(CGFloat(index) / numberOfColumns), width: width, height: height))
            }
        } else {

        }
    }

    func testNavigationController() {
        let viewController = GridViewController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0))

        let collectionView = viewController.collectionView!
        let fractionalWidth: CGFloat = 0.2
        let numberOfColumns: CGFloat = floor(1 / fractionalWidth)
        let width: CGFloat = window.bounds.width * fractionalWidth
        let height = width
        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        if #available(iOS 11.0, *) {
            let safeAreaInsets = viewController.view.safeAreaInsets

            XCTAssertEqual(collectionView.adjustedContentInset, safeAreaInsets)
            XCTAssertEqual(collectionView.contentOffset, CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top))
            XCTAssertEqual(collectionView.contentSize, CGSize(width: window.bounds.width, height: ceil(CGFloat(numberOfItems) / numberOfColumns) * window.bounds.width * fractionalWidth))

            for case (let index, let cell as UICollectionViewCell) in collectionView.subviews.enumerated() {
                XCTAssertEqual(cell.frame, CGRect(x: width * (CGFloat(index).truncatingRemainder(dividingBy: numberOfColumns)), y: height * floor(CGFloat(index) / numberOfColumns), width: width, height: height))
            }
        } else {

        }
    }

    func testTabBarController() {
        let viewController = GridViewController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [viewController]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0))

        let collectionView = viewController.collectionView!
        let fractionalWidth: CGFloat = 0.2
        let numberOfColumns: CGFloat = floor(1 / fractionalWidth)
        let width: CGFloat = window.bounds.width * fractionalWidth
        let height = width
        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        if #available(iOS 11.0, *) {
            let safeAreaInsets = viewController.view.safeAreaInsets

            XCTAssertEqual(collectionView.adjustedContentInset, safeAreaInsets)
            XCTAssertEqual(collectionView.contentOffset, CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top))
            XCTAssertEqual(collectionView.contentSize, CGSize(width: window.bounds.width, height: ceil(CGFloat(numberOfItems) / numberOfColumns) * window.bounds.width * fractionalWidth))

            for case (let index, let cell as UICollectionViewCell) in collectionView.subviews.enumerated() {
                XCTAssertEqual(cell.frame, CGRect(x: width * (CGFloat(index).truncatingRemainder(dividingBy: numberOfColumns)), y: height * floor(CGFloat(index) / numberOfColumns), width: width, height: height))
            }
        } else {

        }
    }

    func testNavigationControllerInTabBarController() {
        let viewController = GridViewController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: viewController)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0))

        let collectionView = viewController.collectionView!
        let fractionalWidth: CGFloat = 0.2
        let numberOfColumns: CGFloat = floor(1 / fractionalWidth)
        let width: CGFloat = window.bounds.width * fractionalWidth
        let height = width
        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        if #available(iOS 11.0, *) {
            let safeAreaInsets = viewController.view.safeAreaInsets

            XCTAssertEqual(collectionView.adjustedContentInset, safeAreaInsets)
            XCTAssertEqual(collectionView.contentOffset, CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top))
            XCTAssertEqual(collectionView.contentSize, CGSize(width: window.bounds.width, height: ceil(CGFloat(numberOfItems) / numberOfColumns) * window.bounds.width * fractionalWidth))

            for case (let index, let cell as UICollectionViewCell) in collectionView.subviews.enumerated() {
                XCTAssertEqual(cell.frame, CGRect(x: width * (CGFloat(index).truncatingRemainder(dividingBy: numberOfColumns)), y: height * floor(CGFloat(index) / numberOfColumns), width: width, height: height))
            }
        } else {

        }
    }
}

class GridViewController: UIViewController {
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Grid"
        configureHierarchy()
        configureDataSource()
    }
}

extension GridViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension GridViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { (collectionView, indexPath, identifier) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

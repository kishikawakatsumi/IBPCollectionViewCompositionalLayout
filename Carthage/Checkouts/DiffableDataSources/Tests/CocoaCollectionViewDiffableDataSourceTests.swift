#if os(macOS)

import XCTest
import AppKit
@testable import DiffableDataSources

final class CocoaCollectionViewDiffableDataSourceTests: XCTestCase {
    func testInit() {
        let collectionView = MockCollectionView()
        let dataSource = CocoaCollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { _, _, _ in
            NSCollectionViewItem()
        }

        XCTAssertTrue(collectionView.dataSource === dataSource)
    }

    func testApply() {
        let collectionView = MockCollectionView()
        let dataSource = CocoaCollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { _, _, _ in
            NSCollectionViewItem()
        }

        let snapshot = DiffableDataSourceSnapshot<Int, Int>()

        dataSource.apply(snapshot)
        XCTAssertEqual(collectionView.isPerformBatchUpdatesCalledCount, 0)

        snapshot.appendSections([0])
        snapshot.appendItems([0])

        dataSource.apply(snapshot)
        XCTAssertEqual(collectionView.isPerformBatchUpdatesCalledCount, 1)

        dataSource.apply(snapshot)
        XCTAssertEqual(collectionView.isPerformBatchUpdatesCalledCount, 1)

        snapshot.appendItems([1])

        dataSource.apply(snapshot)
        XCTAssertEqual(collectionView.isPerformBatchUpdatesCalledCount, 2)
    }

    func testSnapshot() {
        let collectionView = MockCollectionView()
        let dataSource = CocoaCollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { _, _, _ in
            NSCollectionViewItem()
        }

        let snapshot1 = dataSource.snapshot()
        XCTAssertEqual(snapshot1.sectionIdentifiers, [])
        XCTAssertEqual(snapshot1.itemIdentifiers, [])

        dataSource.snapshot().appendSections([0, 1, 2])
        let snapshot2 = dataSource.snapshot()
        XCTAssertEqual(snapshot2.sectionIdentifiers, [])
        XCTAssertEqual(snapshot2.itemIdentifiers, [])

        let snapshotToApply = DiffableDataSourceSnapshot<Int, Int>()
        snapshotToApply.appendSections([0, 1, 2])
        snapshotToApply.appendItems([0, 1, 2])
        dataSource.apply(snapshotToApply)

        let snapshot3 = dataSource.snapshot()
        XCTAssertEqual(snapshot3.sectionIdentifiers, [0, 1, 2])
        XCTAssertEqual(snapshot3.itemIdentifiers, [0, 1, 2])

        dataSource.snapshot().appendSections([3, 4, 5])

        let snapshot4 = dataSource.snapshot()
        XCTAssertEqual(snapshot4.sectionIdentifiers, [0, 1, 2])
        XCTAssertEqual(snapshot4.itemIdentifiers, [0, 1, 2])

        snapshot4.appendSections([3, 4, 5])
        snapshot4.appendItems([3, 4, 5])
        dataSource.apply(snapshot4)

        let snapshot5 = dataSource.snapshot()
        XCTAssertEqual(snapshot5.sectionIdentifiers, [0, 1, 2, 3, 4, 5])
        XCTAssertEqual(snapshot5.itemIdentifiers, [0, 1, 2, 3, 4, 5])
    }

    func testItemIdentifier() {
        let collectionView = MockCollectionView()
        let dataSource = CocoaCollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { _, _, _ in
            NSCollectionViewItem()
        }

        let snapshot = DiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0, 1, 2])
        snapshot.appendItems([0, 1, 2], toSection: 0)
        dataSource.apply(snapshot)

        XCTAssertEqual(dataSource.itemIdentifier(for: IndexPath(item: 1, section: 0)), 1)
        XCTAssertEqual(dataSource.itemIdentifier(for: IndexPath(item: 100, section: 100)), nil)
    }

    func testIndexPath() {
        let collectionView = MockCollectionView()
        let dataSource = CocoaCollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { _, _, _ in
            NSCollectionViewItem()
        }

        let snapshot = DiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0, 1, 2])
        snapshot.appendItems([0, 1, 2], toSection: 0)
        dataSource.apply(snapshot)

        XCTAssertEqual(dataSource.indexPath(for: 2), IndexPath(item: 2, section: 0))
        XCTAssertEqual(dataSource.indexPath(for: 100), nil)
    }

    func testNumberOfSections() {
        let collectionView = MockCollectionView()
        let dataSource = CocoaCollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { _, _, _ in
            NSCollectionViewItem()
        }

        XCTAssertEqual(dataSource.numberOfSections(in: collectionView), 0)

        let snapshot = DiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0, 1, 2])
        snapshot.appendItems([0, 1, 2], toSection: 0)
        dataSource.apply(snapshot)

        XCTAssertEqual(dataSource.numberOfSections(in: collectionView), 3)
    }

    func testNumberOfRowsInSection() {
        let collectionView = MockCollectionView()
        let dataSource = CocoaCollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { _, _, _ in
            NSCollectionViewItem()
        }

        let snapshot = DiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0, 1, 2])
        snapshot.appendItems([0, 1, 2], toSection: 0)
        dataSource.apply(snapshot)

        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), 3)
    }

    func testCellForRowAt() {
        let collectionView = MockCollectionView()
        let item = NSCollectionViewItem()
        let dataSource = CocoaCollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { _, _, _ in
            item
        }

        let snapshot = DiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0, 1, 2])
        snapshot.appendItems([0, 1, 2], toSection: 0)
        dataSource.apply(snapshot)

        XCTAssertEqual(
            dataSource.collectionView(collectionView, itemForRepresentedObjectAt: IndexPath(item: 1, section: 0)),
            item
        )
    }
}

final class MockCollectionView: NSCollectionView {
    var isPerformBatchUpdatesCalledCount = 0

    init() {
        super.init(frame: .zero)

        let window = NSWindow()
        window.contentView = self
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func performBatchUpdates(_ updates: (() -> Void)?, completionHandler: ((Bool) -> Void)? = nil) {
        isPerformBatchUpdatesCalledCount += 1
        updates?()
        completionHandler?(true)
    }

    override func insertItems(at indexPaths: Set<IndexPath>) {}
}

#endif

#if os(macOS)

import AppKit
import DifferenceKit

/// A class for backporting `NSCollectionViewDiffableDataSource` introduced in macOS 10.15+.
/// Represents the data model object for `NSCollectionView` that can be applies the
/// changes with automatic diffing.
open class CocoaCollectionViewDiffableDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: NSObject, NSCollectionViewDataSource {
    /// The type of closure providing the item.
    public typealias ItemProvider = (NSCollectionView, IndexPath, ItemIdentifierType) -> NSCollectionViewItem?

    private weak var collectionView: NSCollectionView?
    private let itemProvider: ItemProvider
    private let core = DiffableDataSourceCore<SectionIdentifierType, ItemIdentifierType>()

    /// Creates a new data source.
    ///
    /// - Parameters:
    ///   - collectionView: A collection view instance to be managed.
    ///   - itemProvider: A closure to make the item.
    public init(collectionView: NSCollectionView, itemProvider: @escaping ItemProvider) {
        self.collectionView = collectionView
        self.itemProvider = itemProvider
        super.init()

        collectionView.dataSource = self
    }

    /// Applies given snapshot to perform automatic diffing update.
    ///
    /// - Parameters:
    ///   - snapshot: A snapshot object to be applied to data model.
    ///   - animatingDifferences: A Boolean value indicating whether to update with
    ///                           diffing animation.
    public func apply(_ snapshot: DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool = true) {
        core.apply(
            snapshot,
            view: collectionView,
            animatingDifferences: animatingDifferences,
            performUpdates: { collectionView, changeset, setSections in
                collectionView.reload(using: changeset, setData: setSections)
        })
    }

    /// Returns a new snapshot object of current state.
    ///
    /// - Returns: A new snapshot object of current state.
    public func snapshot() -> DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
        return core.snapshot()
    }

    /// Returns an item identifier for given index path.
    ///
    /// - Parameters:
    ///   - indexPath: An index path for the item identifier.
    ///
    /// - Returns: An item identifier for given index path.
    public func itemIdentifier(for indexPath: IndexPath) -> ItemIdentifierType? {
        return core.itemIdentifier(for: indexPath)
    }

    /// Returns an index path for given item identifier.
    ///
    /// - Parameters:
    ///   - itemIdentifier: An identifier of item.
    ///
    /// - Returns: An index path for given item identifier.
    public func indexPath(for itemIdentifier: ItemIdentifierType) -> IndexPath? {
        return core.indexPath(for: itemIdentifier)
    }

    /// Returns the number of sections in the data source.
    ///
    /// - Parameters:
    ///   - collectionView: A collection view instance managed by `self`.
    ///
    /// - Returns: The number of sections in the data source.
    public func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return core.numberOfSections()
    }

    /// Returns the number of items in the specified section.
    ///
    /// - Parameters:
    ///   - collectionView: A collection view instance managed by `self`.
    ///   - section: An index of section.
    ///
    /// - Returns: The number of items in the specified section.
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return core.numberOfItems(inSection: section)
    }

    /// Returns an item at specified index path.
    ///
    /// - Parameters:
    ///   - collectionView: A collection view instance managed by `self`.
    ///   - indexPath: An index path for item.
    ///
    /// - Returns: An item at specified index path.
    open func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let itemIdentifier = core.unsafeItemIdentifier(for: indexPath)
        guard let item = itemProvider(collectionView, indexPath, itemIdentifier) else {
            universalError("NSCollectionView dataSource returned a nil item at index path: \(indexPath), collectionView: \(collectionView), itemIdentifier: \(itemIdentifier)")
        }

        return item
    }
}

#endif

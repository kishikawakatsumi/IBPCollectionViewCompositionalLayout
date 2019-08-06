#if os(iOS) || os(tvOS)

import UIKit
import DifferenceKit

/// A class for backporting `UITableViewDiffableDataSource` introduced in iOS 13.0+, tvOS 13.0+.
/// Represents the data model object for `UITableView` that can be applies the
/// changes with automatic diffing.
open class TableViewDiffableDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: NSObject, UITableViewDataSource {
    /// The type of closure providing the cell.
    public typealias CellProvider = (UITableView, IndexPath, ItemIdentifierType) -> UITableViewCell?

    /// The default animation to updating the views.
    public var defaultRowAnimation: UITableView.RowAnimation = .automatic

    private weak var tableView: UITableView?
    private let cellProvider: CellProvider
    private let core = DiffableDataSourceCore<SectionIdentifierType, ItemIdentifierType>()

    /// Creates a new data source.
    ///
    /// - Parameters:
    ///   - tableView: A table view instance to be managed.
    ///   - cellProvider: A closure to dequeue the cell for rows.
    public init(tableView: UITableView, cellProvider: @escaping CellProvider) {
        self.tableView = tableView
        self.cellProvider = cellProvider
        super.init()

        tableView.dataSource = self
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
            view: tableView,
            animatingDifferences: animatingDifferences,
            performUpdates: { tableView, changeset, setSections in
                tableView.reload(using: changeset, with: self.defaultRowAnimation, setData: setSections)
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
    ///   - tableView: A table view instance managed by `self`.
    ///
    /// - Returns: The number of sections in the data source.
    public func numberOfSections(in tableView: UITableView) -> Int {
        return core.numberOfSections()
    }

    /// Returns the number of items in the specified section.
    ///
    /// - Parameters:
    ///   - tableView: A table view instance managed by `self`.
    ///   - section: An index of section.
    ///
    /// - Returns: The number of items in the specified section.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return core.numberOfItems(inSection: section)
    }

    /// Returns a cell for row at specified index path.
    ///
    /// - Parameters:
    ///   - tableView: A table view instance managed by `self`.
    ///   - indexPath: An index path for cell.
    ///
    /// - Returns: A cell for row at specified index path.
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemIdentifier = core.unsafeItemIdentifier(for: indexPath)
        guard let cell = cellProvider(tableView, indexPath, itemIdentifier) else {
            universalError("UITableView dataSource returned a nil cell for row at index path: \(indexPath), tableView: \(tableView), itemIdentifier: \(itemIdentifier)")
        }

        return cell
    }
}

#endif

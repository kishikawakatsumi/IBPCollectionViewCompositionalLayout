/// A class for backporting `NSDiffableDataSourceSnapshot` introduced in iOS 13.0+, macOS 10.15+, tvOS 13.0+.
/// Represents the mutable state of diffable data source of UI.
public struct DiffableDataSourceSnapshot<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable> {
    internal var structure = SnapshotStructure<SectionIdentifierType, ItemIdentifierType>()

    /// Creates a new empty snapshot object.
    public init() {}

    /// The number of item identifiers in the snapshot.
    public var numberOfItems: Int {
        return itemIdentifiers.count
    }

    /// The number of section identifiers in the snapshot.
    public var numberOfSections: Int {
        return sectionIdentifiers.count
    }

    /// All section identifiers in the snapshot.
    public var sectionIdentifiers: [SectionIdentifierType] {
        return structure.allSectionIDs
    }

    /// All item identifiers in the snapshot.
    public var itemIdentifiers: [ItemIdentifierType] {
        return structure.allItemIDs
    }

    /// Returns the number of item identifiers in the specified section.
    ///
    /// - Parameters:
    ///   - identifier: An identifier of section.
    ///
    /// - Returns: The number of item identifiers in the specified section.
    public func numberOfItems(inSection identifier: SectionIdentifierType) -> Int {
        return itemIdentifiers(inSection: identifier).count
    }

    /// Returns the item identifiers in the specified section.
    ///
    /// - Parameters:
    ///   - identifier: An identifier of section.
    ///
    /// - Returns: The item identifiers in the specified section.
    public func itemIdentifiers(inSection identifier: SectionIdentifierType) -> [ItemIdentifierType] {
        return structure.items(in: identifier)
    }

    /// Returns a section identifier containing the specified item.
    ///
    /// - Parameters:
    ///   - identifier: An identifier of item.
    ///
    /// - Returns: A section identifier containing the specified item.
    public func sectionIdentifier(containingItem identifier: ItemIdentifierType) -> SectionIdentifierType? {
        return structure.section(containing: identifier)
    }

    /// Returns an index of the specified item.
    ///
    /// - Parameters:
    ///   - identifier: An identifier of item.
    ///
    /// - Returns: An index of the specified item.
    public func indexOfItem(_ identifier: ItemIdentifierType) -> Int? {
        return itemIdentifiers.firstIndex { $0.isEqualHash(to: identifier) }
    }

    /// Returns an index of the specified section.
    ///
    /// - Parameters:
    ///   - identifier: An identifier of section.
    ///
    /// - Returns: An index of the specified section.
    public func indexOfSection(_ identifier: SectionIdentifierType) -> Int? {
        return sectionIdentifiers.firstIndex { $0.isEqualHash(to: identifier) }
    }

    /// Appends the given item identifiers to the specified section or last section.
    ///
    /// - Parameters:
    ///   - identifiers: The item identifiers to be appended.
    ///   - sectionIdentifier: An identifier of section to append the given identiciers.
    public mutating func appendItems(_ identifiers: [ItemIdentifierType], toSection sectionIdentifier: SectionIdentifierType? = nil) {
        structure.append(itemIDs: identifiers, to: sectionIdentifier)
    }

    /// Inserts the given item identifiers before the specified item.
    ///
    /// - Parameters:
    ///   - identifiers: The item identifiers to be inserted.
    ///   - beforeIdentifier: An identifier of item.
    public mutating func insertItems(_ identifiers: [ItemIdentifierType], beforeItem beforeIdentifier: ItemIdentifierType) {
        structure.insert(itemIDs: identifiers, before: beforeIdentifier)
    }

    /// Inserts the given item identifiers after the specified item.
    ///
    /// - Parameters:
    ///   - identifiers: The item identifiers to be inserted.
    ///   - afterIdentifier: An identifier of item.
    public mutating func insertItems(_ identifiers: [ItemIdentifierType], afterItem afterIdentifier: ItemIdentifierType) {
        structure.insert(itemIDs: identifiers, after: afterIdentifier)
    }

    /// Deletes the specified items.
    ///
    /// - Parameters:
    ///   - identifiers: The item identifiers to be deleted.
    public mutating func deleteItems(_ identifiers: [ItemIdentifierType]) {
        structure.remove(itemIDs: identifiers)
    }

    /// Deletes the all items in the snapshot.
    public mutating func deleteAllItems() {
        structure.removeAllItems()
    }

    /// Moves the given item identifier before the specified item.
    ///
    /// - Parameters:
    ///   - identifier: An item identifier to be moved.
    ///   - toIdentifier: An identifier of item.
    public mutating func moveItem(_ identifier: ItemIdentifierType, beforeItem toIdentifier: ItemIdentifierType) {
        structure.move(itemID: identifier, before: toIdentifier)
    }

    /// Moves the given item identifier after the specified item.
    ///
    /// - Parameters:
    ///   - identifier: An item identifier to be moved.
    ///   - toIdentifier: An identifier of item.
    public mutating func moveItem(_ identifier: ItemIdentifierType, afterItem toIdentifier: ItemIdentifierType) {
        structure.move(itemID: identifier, after: toIdentifier)
    }

    /// Reloads the specified items.
    ///
    /// - Parameters:
    ///   - identifiers: The item identifiers to be reloaded.
    public mutating func reloadItems(_ identifiers: [ItemIdentifierType]) {
        structure.update(itemIDs: identifiers)
    }

    /// Appends the given section identifiers to the end of sections.
    ///
    /// - Parameters:
    ///   - identifiers: The section identifiers to be appended.
    public mutating func appendSections(_ identifiers: [SectionIdentifierType]) {
        structure.append(sectionIDs: identifiers)
    }

    /// Inserts the given section identifiers before the specified section.
    ///
    /// - Parameters:
    ///   - identifiers: The section identifiers to be inserted.
    ///   - toIdentifier: An identifier of setion.
    public mutating func insertSections(_ identifiers: [SectionIdentifierType], beforeSection toIdentifier: SectionIdentifierType) {
        structure.insert(sectionIDs: identifiers, before: toIdentifier)
    }

    /// Inserts the given section identifiers after the specified section.
    ///
    /// - Parameters:
    ///   - identifiers: The section identifiers to be inserted.
    ///   - toIdentifier: An identifier of setion.
    public mutating func insertSections(_ identifiers: [SectionIdentifierType], afterSection toIdentifier: SectionIdentifierType) {
        structure.insert(sectionIDs: identifiers, after: toIdentifier)
    }

    /// Deletes the specified sections.
    ///
    /// - Parameters:
    ///   - identifiers: The section identifiers to be deleted.
    public mutating func deleteSections(_ identifiers: [SectionIdentifierType]) {
        structure.remove(sectionIDs: identifiers)
    }

    /// Moves the given section identifier before the specified section.
    ///
    /// - Parameters:
    ///   - identifier: A section identifier to be moved.
    ///   - toIdentifier: An identifier of section.
    public mutating func moveSection(_ identifier: SectionIdentifierType, beforeSection toIdentifier: SectionIdentifierType) {
        structure.move(sectionID: identifier, before: toIdentifier)
    }

    /// Moves the given section identifier after the specified section.
    ///
    /// - Parameters:
    ///   - identifier: A section identifier to be moved.
    ///   - toIdentifier: An identifier of section.
    public mutating func moveSection(_ identifier: SectionIdentifierType, afterSection toIdentifier: SectionIdentifierType) {
        structure.move(sectionID: identifier, after: toIdentifier)
    }

    /// Reloads the specified sections.
    ///
    /// - Parameters:
    ///   - identifiers: The section identifiers to be reloaded.
    public mutating func reloadSections(_ identifiers: [SectionIdentifierType]) {
        structure.update(sectionIDs: identifiers)
    }
}

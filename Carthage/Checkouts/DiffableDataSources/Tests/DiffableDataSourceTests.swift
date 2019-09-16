import XCTest
@testable import DiffableDataSources

// swiftlint:disable file_length
// swiftlint:disable type_body_length

final class DiffableDataSourceSnapshotTests: XCTestCase {
    func testAppendSections() {
        typealias Test = (initial: [Int], append: [Int], expected: [Int])

        let tests: [Test] = [
            ([0, 1], [], [0, 1]),
            ([], [0, 1, 2], [0, 1, 2]),
            ([0, 1], [2, 3, 4], [0, 1, 2, 3, 4]),
            ([0, 1], [4, 3, 2], [0, 1, 4, 3, 2])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)
            snapshot.appendSections(test.append)
            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testAppendSectionsDuplication() {
        typealias Test = (initial: [Int], append: [Int], expected: [Int])

        let tests: [Test] = [
            ([0, 1], [0], [0, 1, 0]),
            ([0, 1], [0, 1], [0, 1, 0, 1]),
            ([0, 1], [2, 2], [0, 1, 2, 2])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)
            snapshot.appendSections(test.append)
            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testInsertSectionsBeforeSection() {
        typealias Test = (initial: [Int], insert: [Int], before: Int, expected: [Int])

        let tests: [Test] = [
            ([0, 1], [3, 4], 1, [0, 3, 4, 1]),
            ([0, 1], [3, 4], 0, [3, 4, 0, 1]),
            ([0, 1, 2], [3, 4], 2, [0, 1, 3, 4, 2]),
            ([0, 1, 2], [], 2, [0, 1, 2])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)
            snapshot.insertSections(test.insert, beforeSection: test.before)
            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testInsertSectionsBeforeSectionDuplication() {
        typealias Test = (initial: [Int], insert: [Int], before: Int, expected: [Int])

        let tests: [Test] = [
            ([0, 1], [1], 0, [1, 0, 1]),
            ([0, 1], [2, 2], 1, [0, 2, 2, 1])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)
            snapshot.insertSections(test.insert, beforeSection: test.before)
            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testInsertSectionsAfterSection() {
        typealias Test = (initial: [Int], insert: [Int], after: Int, expected: [Int])

        let tests: [Test] = [
            ([0, 1], [3, 4], 1, [0, 1, 3, 4]),
            ([0, 1], [3, 4], 0, [0, 3, 4, 1]),
            ([0, 1, 2], [3, 4], 2, [0, 1, 2, 3, 4]),
            ([0, 1, 2], [], 2, [0, 1, 2]),
            ([0], [1], 0, [0, 1])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)
            snapshot.insertSections(test.insert, afterSection: test.after)
            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testInsertSectionsAfterSectionDuplication() {
        typealias Test = (initial: [Int], insert: [Int], after: Int, expected: [Int])

        let tests: [Test] = [
            ([0, 1], [1], 0, [0, 1, 1]),
            ([0, 1], [2, 2], 1, [0, 1, 2, 2])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)
            snapshot.insertSections(test.insert, afterSection: test.after)
            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testDeleteSections() {
        typealias Test = (initial: [Int], delete: [Int], expected: [Int])

        let tests: [Test] = [
            ([0, 1], [1], [0]),
            ([0, 1], [0], [1]),
            ([0, 1, 2], [1], [0, 2]),
            ([0, 1], [1], [0]),
            ([], [1], []),
            ([0, 1], [100], [0, 1])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)
            snapshot.deleteSections(test.delete)
            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testMoveSectionBeforeSection() {
        typealias Test = (initial: [Int], move: Int, before: Int, expected: [Int])

        let tests: [Test] = [
            ([0, 1], 1, 0, [1, 0]),
            ([0, 1, 2], 2, 0, [2, 0, 1]),
            ([0, 1, 2], 0, 2, [1, 0, 2]),
            ([0, 1, 2], 1, 2, [0, 1, 2])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)
            snapshot.moveSection(test.move, beforeSection: test.before)
            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testMoveSectionAfterSection() {
        typealias Test = (initial: [Int], move: Int, after: Int, expected: [Int])

        let tests: [Test] = [
            ([0, 1], 0, 1, [1, 0]),
            ([0, 1, 2], 2, 0, [0, 2, 1]),
            ([0, 1, 2], 0, 2, [1, 2, 0]),
            ([0, 1, 2], 1, 0, [0, 1, 2])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)
            snapshot.moveSection(test.move, afterSection: test.after)
            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testReloadSections() {
        typealias Section = SnapshotStructure<Int, Int>.Section
        typealias Test = (initial: [Int], reload: [Int], sections: [Section])

        let tests: [Test] = [
            ([], [], []),
            ([0], [1], [
                Section(id: 0, items: [], isReloaded: false)
                ]
            ),
            ([0], [0], [
                Section(id: 0, items: [], isReloaded: true)
                ]
            ),
            ([0, 1, 2], [2], [
                Section(id: 0, items: [], isReloaded: false),
                Section(id: 1, items: [], isReloaded: false),
                Section(id: 2, items: [], isReloaded: true)
                ]
            ),
            ([2, 1, 0], [0, 1], [
                Section(id: 2, items: [], isReloaded: false),
                Section(id: 1, items: [], isReloaded: true),
                Section(id: 0, items: [], isReloaded: true)
                ]
            )
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)
            snapshot.reloadSections(test.reload)
            XCTAssertEqual(snapshot.sectionIdentifiers, test.initial)

            XCTAssertEqual(snapshot.structure.sections, test.sections)
        }
    }

    func testAppendItems() {
        typealias Test = (initial: [Int], append: [Int], expected: [Int])

        let tests: [Test] = [
            ([0, 1], [2, 3], [0, 1, 2, 3]),
            ([], [2, 3], [2, 3]),
            ([1], [0], [1, 0])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections([0, 1])
            snapshot.appendItems(test.initial)
            snapshot.appendItems(test.append)

            XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expected)
        }
    }

    func testAppendItemsDuplication() {
        typealias Test = (initial: [Int], append: [Int], expected: [Int])

        let tests: [Test] = [
            ([1], [1, 2], [1, 1, 2]),
            ([1], [2, 2], [1, 2, 2])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections([0, 1])
            snapshot.appendItems(test.initial)
            snapshot.appendItems(test.append)

            XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expected)
        }
    }

    func testAppendItemsToSection() {
        typealias Test = (initial: [[Int]], append: [Int], section: Int, expected: [[Int]])

        let tests: [Test] = [
            ([[], [0, 1]], [2, 3], 1, [[], [0, 1, 2, 3]]),
            ([[], []], [2, 3], 1, [[], [2, 3]]),
            ([[], [1]], [0], 1, [[], [1, 0]]),
            ([[], [1]], [2], 0, [[2], [1]]),
            ([[], [1]], [2, 3], 0, [[2, 3], [1]]),
            ([[], []], [0], 0, [[0], []])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items)
            }

            snapshot.appendItems(test.append, toSection: test.section)

            for (section, items) in test.expected.enumerated() {
                XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
            }
        }
    }

    func testAppendItemsToSectionDuplication() {
        typealias Test = (initial: [[Int]], append: [Int], section: Int, expected: [[Int]])

        let tests: [Test] = [
            ([[], [1]], [1, 2], 1, [[], [1, 1, 2]]),
            ([[], [1]], [2, 2], 1, [[], [1, 2, 2]])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items)
            }

            snapshot.appendItems(test.append, toSection: test.section)

            for (section, items) in test.expected.enumerated() {
                XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
            }
        }
    }

    func testInsertItemsBeforeItem() {
        typealias Test = (initial: [Int], insert: [Int], before: Int, expected: [Int])

        let tests: [Test] = [
            ([0, 1], [2, 3], 1, [0, 2, 3, 1]),
            ([0, 1], [2, 3], 0, [2, 3, 0, 1]),
            ([0, 1, 2], [3, 4], 1, [0, 3, 4, 1, 2]),
            ([0, 1, 2], [], 1, [0, 1, 2]),
            ([0], [1], 0, [1, 0])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections([0, 1])
            snapshot.appendItems(test.initial)
            snapshot.insertItems(test.insert, beforeItem: test.before)

            XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expected)
        }
    }

    func testInsertItemsBeforeItemDuplication() {
        typealias Test = (initial: [Int], insert: [Int], before: Int, expected: [Int])

        let tests: [Test] = [
            ([1], [1, 2], 1, [1, 2, 1]),
            ([1], [2, 2], 1, [2, 2, 1])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections([0, 1])
            snapshot.appendItems(test.initial)
            snapshot.insertItems(test.insert, beforeItem: test.before)

            XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expected)
        }
    }

    func testInsertItemsAfterItem() {
        typealias Test = (initial: [Int], insert: [Int], after: Int, expected: [Int])

        let tests: [Test] = [
            ([0, 1], [2, 3], 1, [0, 1, 2, 3]),
            ([0, 1], [2, 3], 0, [0, 2, 3, 1]),
            ([0, 1, 2], [3, 4], 1, [0, 1, 3, 4, 2]),
            ([0, 1, 2], [], 1, [0, 1, 2]),
            ([0], [1], 0, [0, 1])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections([0, 1])
            snapshot.appendItems(test.initial)
            snapshot.insertItems(test.insert, afterItem: test.after)

            XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expected)
        }
    }

    func testInsertItemsAfterItemDuplication() {
        typealias Test = (initial: [Int], insert: [Int], after: Int, expected: [Int])

        let tests: [Test] = [
            ([1], [1, 2], 1, [1, 1, 2]),
            ([1], [2, 2], 1, [1, 2, 2])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections([0, 1])
            snapshot.appendItems(test.initial)
            snapshot.insertItems(test.insert, afterItem: test.after)

            XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expected)
        }
    }

    func testDeleteItems() {
        typealias Test = (initial: [[Int]], delete: [Int], expected: [[Int]])

        let tests: [Test] = [
            ([[], [0, 1]], [0], [[], [1]]),
            ([[0, 1], [2, 3]], [0, 2], [[1], [3]]),
            ([[], []], [100], [[], []]),
            ([[0, 1], [2, 3]], [0, 1], [[], [2, 3]]),
            ([[0, 1], [2, 3]], [0], [[1], [2, 3]]),
            ([[0, 1], [2, 3]], [0, 1, 2, 3], [[], []]),
            ([[0, 1], [2, 3]], [0, 1, 2, 3, 4, 5], [[], []])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            snapshot.deleteItems(test.delete)

            for (section, items) in test.expected.enumerated() {
                XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
            }
        }
    }

    func testDeleteAllItems() {
        typealias Test = [[Int]]

        let tests: [Test] = [
            ([[], [0, 1]]),
            ([[0], [1]]),
            ([[], []]),
            ([[0, 1], [2, 3]]),
            ([[0, 1, 2], []]),
            ([[], [0, 1, 2]])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            snapshot.deleteAllItems()

            XCTAssertEqual(snapshot.itemIdentifiers, [])
        }
    }

    func testMoveItemsBeforeItem() {
        typealias Test = (initial: [[Int]], move: Int, before: Int, expected: [[Int]])

        let tests: [Test] = [
            ([[0, 1], [2, 3]], 0, 2, [[1], [0, 2, 3]]),
            ([[0, 1], [2, 3]], 1, 0, [[1, 0], [2, 3]]),
            ([[0, 1], [2, 3]], 3, 0, [[3, 0, 1], [2]]),
            ([[0, 1], [2, 3]], 2, 3, [[0, 1], [2, 3]]),
            ([[0], [1]], 0, 1, [[], [0, 1]]),
            ([[0], [1]], 1, 0, [[1, 0], []]),
            ([[], [0, 1]], 1, 0, [[], [1, 0]])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            snapshot.moveItem(test.move, beforeItem: test.before)

            for (section, items) in test.expected.enumerated() {
                XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
            }
        }
    }

    func testMoveItemsAfterItem() {
        typealias Test = (initial: [[Int]], move: Int, after: Int, expected: [[Int]])

        let tests: [Test] = [
            ([[0, 1], [2, 3]], 0, 2, [[1], [2, 0, 3]]),
            ([[0, 1], [2, 3]], 1, 0, [[0, 1], [2, 3]]),
            ([[0, 1], [2, 3]], 3, 0, [[0, 3, 1], [2]]),
            ([[0, 1], [2, 3]], 2, 3, [[0, 1], [3, 2]]),
            ([[0], [1]], 0, 1, [[], [1, 0]]),
            ([[0], [1]], 1, 0, [[0, 1], []]),
            ([[], [0, 1]], 1, 0, [[], [0, 1]])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            snapshot.moveItem(test.move, afterItem: test.after)

            for (section, items) in test.expected.enumerated() {
                XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
            }
        }
    }

    func testReloadItems() {
        typealias Section = SnapshotStructure<Int, Int>.Section
        typealias Item = SnapshotStructure<Int, Int>.Item
        typealias Test = (initial: [[Int]], reload: [Int], sections: [Section])

        let tests: [Test] = [
            ([[], []], [], [
                Section(id: 0, items: [], isReloaded: false),
                Section(id: 1, items: [], isReloaded: false)
                ]
            ),
            ([[], [0]], [0], [
                Section(id: 0, items: [], isReloaded: false),
                Section(
                    id: 1,
                    items: [
                        Item(id: 0, isReloaded: true)
                    ],
                    isReloaded: false
                )
                ]
            ),
            ([[0, 1], [2]], [1, 2], [
                Section(
                    id: 0,
                    items: [
                        Item(id: 0, isReloaded: false),
                        Item(id: 1, isReloaded: true)
                    ],
                    isReloaded: false
                ),
                Section(
                    id: 1,
                    items: [
                        Item(id: 2, isReloaded: true)
                    ],
                    isReloaded: false
                )
                ]
            ),
            ([[0, 1], [2, 3]], [0, 2, 3], [
                Section(
                    id: 0,
                    items: [
                        Item(id: 0, isReloaded: true),
                        Item(id: 1, isReloaded: false)
                    ],
                    isReloaded: false
                ),
                Section(
                    id: 1,
                    items: [
                        Item(id: 2, isReloaded: true),
                        Item(id: 3, isReloaded: true)
                    ],
                    isReloaded: false
                )
                ]
            )
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            snapshot.reloadItems(test.reload)

            XCTAssertEqual(snapshot.itemIdentifiers, test.initial.flatMap { $0 })

            XCTAssertEqual(snapshot.structure.sections, test.sections)
        }
    }

    func testNumberOfItems() {
        typealias Test = (initial: [[Int]], expected: Int)

        let tests: [Test] = [
            ([[0, 1], [2, 3]], 4),
            ([[0, 1], []], 2),
            ([[], [2, 3]], 2),
            ([[], []], 0)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.numberOfItems, test.expected)
        }
    }

    func testNumberOfItemsDuplication() {
        typealias Test = (initial: [[Int]], expected: Int)

        let tests: [Test] = [
            ([[0, 1], [1, 2]], 4),
            ([[0, 0], []], 2)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.numberOfItems, test.expected)
        }
    }

    func testNumberOfSections() {
        typealias Test = (initial: [Int], expected: Int)

        let tests: [Test] = [
            ([], 0),
            ([0, 1, 2], 3)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)

            XCTAssertEqual(snapshot.numberOfSections, test.expected)
        }
    }

    func testNumberOfSectionsDuplication() {
        typealias Test = (initial: [Int], expected: Int)

        let tests: [Test] = [
            ([0, 0], 2),
            ([0, 1, 1], 3)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)

            XCTAssertEqual(snapshot.numberOfSections, test.expected)
        }
    }

    func testItemIdentifiers() {
        typealias Test = (initial: [[Int]], expected: [Int])

        let tests: [Test] = [
            ([[0, 1], [2, 3]], [0, 1, 2, 3]),
            ([[0, 1], []], [0, 1]),
            ([[], [2, 3]], [2, 3]),
            ([[], []], [])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.itemIdentifiers, test.expected)
        }
    }

    func testItemIdentifiersDuplication() {
        typealias Test = (initial: [[Int]], expected: [Int])

        let tests: [Test] = [
            ([[0, 1], [1, 2]], [0, 1, 1, 2]),
            ([[0, 0], [1, 2]], [0, 0, 1, 2])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.itemIdentifiers, test.expected)
        }
    }

    func testSectionIdentifiers() {
        typealias Test = (initial: [Int], expected: [Int])

        let tests: [Test] = [
            ([], []),
            ([0, 1], [0, 1])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)

            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testSectionIdentifiersDuplication() {
        typealias Test = (initial: [Int], expected: [Int])

        let tests: [Test] = [
            ([0, 0], [0, 0]),
            ([0, 1, 1], [0, 1, 1])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)

            XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
        }
    }

    func testNumberOfItemsInSection() {
        typealias Test = (initial: [[Int]], expectedInRight: Int)

        let tests: [Test] = [
            ([[0, 1], [2, 3]], 2),
            ([[0, 1], []], 0),
            ([[], [2, 3]], 2),
            ([[], []], 0)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.numberOfItems(inSection: 1), test.expectedInRight)
        }
    }

    func testNumberOfItemsInSectionDuplication() {
        typealias Test = (initial: [[Int]], expectedInRight: Int)

        let tests: [Test] = [
            ([[0], [1, 1]], 2),
            ([[0, 1], [1, 2]], 2)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.numberOfItems(inSection: 1), test.expectedInRight)
        }
    }

    func testItemIdentifiersInSection() {
        typealias Test = (initial: [[Int]], expectedInRight: [Int])

        let tests: [Test] = [
            ([[0, 1], [2, 3]], [2, 3]),
            ([[0, 1], []], []),
            ([[], [2, 3]], [2, 3]),
            ([[], []], [])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expectedInRight)
        }
    }

    func testItemIdentifiersInSectionDuplication() {
        typealias Test = (initial: [[Int]], expectedInRight: [Int])

        let tests: [Test] = [
            ([[0, 1], [1, 2]], [1, 2]),
            ([[0, 1], [2, 2]], [2, 2])
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expectedInRight)
        }
    }

    func testSectionIdentifiersContainingItem() {
        typealias Test = (initial: [[Int]], item: Int, expected: Int?)

        let tests: [Test] = [
            ([[0, 1], [2, 3]], 2, 1),
            ([[0, 1], []], 0, 0),
            ([[], [2, 3]], 2, 1),
            ([[], []], 0, nil),
            ([[0], [1]], 2, nil)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.sectionIdentifier(containingItem: test.item), test.expected)
        }
    }

    func testSectionIdentifiersContainingDulication() {
        typealias Test = (initial: [[Int]], item: Int, expected: Int?)

        let tests: [Test] = [
            ([[0, 1], [1, 2]], 2, 1),
            ([[0, 1], [1, 2]], 1, 1)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.sectionIdentifier(containingItem: test.item), test.expected)
        }
    }

    func testIndexOfItem() {
        typealias Test = (initial: [[Int]], item: Int, expectedIndex: Int?)

        let tests: [Test] = [
            ([[0, 1], [2, 3]], 2, 2),
            ([[0, 1], []], 0, 0),
            ([[], [2, 3]], 2, 0),
            ([[], []], 0, nil),
            ([[0], [1]], 2, nil)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.indexOfItem(test.item), test.expectedIndex)
        }
    }

    func testIndexOfItemDuplication() {
        typealias Test = (initial: [[Int]], item: Int, expectedIndex: Int?)

        let tests: [Test] = [
            ([[0, 1], [1, 2]], 2, 3),
            ([[0, 1], [1, 2]], 1, 1)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            for (section, items) in test.initial.enumerated() {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            XCTAssertEqual(snapshot.indexOfItem(test.item), test.expectedIndex)
        }
    }

    func testIndexOfSection() {
        typealias Test = (initial: [Int], section: Int, expectedIndex: Int?)

        let tests: [Test] = [
            ([0, 1, 2], 1, 1),
            ([0, 1, 2], 2, 2),
            ([0, 1, 2], 3, nil),
            ([], 0, nil)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)

            XCTAssertEqual(snapshot.indexOfSection(test.section), test.expectedIndex)
        }
    }

    func testIndexOfSectionDuplication() {
        typealias Test = (initial: [Int], section: Int, expectedIndex: Int?)

        let tests: [Test] = [
            ([0, 1, 1, 2], 1, 1),
            ([0, 1, 1, 2], 2, 3)
        ]

        for test in tests {
            var snapshot = DiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections(test.initial)

            XCTAssertEqual(snapshot.indexOfSection(test.section), test.expectedIndex)
        }
    }
}

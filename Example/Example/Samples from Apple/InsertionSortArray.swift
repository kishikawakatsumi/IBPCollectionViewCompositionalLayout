/*
See LICENSE folder for this sample’s licensing information.

Abstract:
`InsertionSortArray` provides a self sorting array class
*/

import UIKit

class InsertionSortArray: Hashable {

    struct SortNode: Hashable {
        let value: Int
        let color: UIColor

        init(value: Int, maxValue: Int) {
            self.value = value
            let hue = CGFloat(value) / CGFloat(maxValue)
            self.color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        private let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        static func == (lhs: SortNode, rhs: SortNode) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }
    var values: [SortNode] {
        return nodes
    }
    var isSorted: Bool {
        return isSortedInternal
    }
    func sortNext() {
        performNextSortStep()
    }
    init(count: Int) {
        nodes = (0..<count).map { SortNode(value: $0, maxValue: count) }.shuffled()
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: InsertionSortArray, rhs: InsertionSortArray) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    private var identifier = UUID()
    private var currentIndex = 1
    private var isSortedInternal = false
    private var nodes: [SortNode]
}

extension InsertionSortArray {
    fileprivate func performNextSortStep() {
        if isSortedInternal {
            return
        }
        if nodes.count == 1 {
            isSortedInternal = true
            return
        }

        var index = currentIndex
        let currentNode = nodes[index]
        index -= 1
        while index >= 0 && currentNode.value < nodes[index].value {
            let tmp = nodes[index]
            nodes[index] = currentNode
            nodes[index + 1] = tmp
            index -= 1
        }
        currentIndex += 1
        if currentIndex >= nodes.count {
            isSortedInternal = true
        }
    }
}

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Controller object that manages our Mountain values and allows for searches
*/

import UIKit

class MountainsController {

    struct Mountain: Hashable {
        let name: String
        let height: Int
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        static func == (lhs: Mountain, rhs: Mountain) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        func contains(_ filter: String?) -> Bool {
            guard let filterText = filter else { return true }
            if filterText.isEmpty { return true }
            let lowercasedFilter = filterText.lowercased()
            return name.lowercased().contains(lowercasedFilter)
        }
    }
    func filteredMountains(with filter: String?) -> [Mountain] {
        return mountains.filter { $0.contains(filter) }
    }
    private lazy var mountains: [Mountain] = {
        return generateMountains()
    }()
}

extension MountainsController {
    private func generateMountains() -> [Mountain] {
        let components = mountainsRawData.components(separatedBy: CharacterSet.newlines)
        var mountains = [Mountain]()
        for line in components {
            let mountainComponents = line.components(separatedBy: ",")
            let name = mountainComponents[0]
            let height = Int(mountainComponents[1])
            mountains.append(Mountain(name: name, height: height!))
        }
        return mountains
    }
}

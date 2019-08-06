extension Hashable {
    func isEqualHash(to other: Self) -> Bool {
        return hashValue == other.hashValue && self == other
    }
}

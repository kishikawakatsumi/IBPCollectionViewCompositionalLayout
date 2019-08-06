func universalError(_ message: String, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("[DiffableDataSources] \(message)", file: file, line: line)
}

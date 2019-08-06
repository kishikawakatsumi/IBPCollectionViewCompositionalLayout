import Foundation

final class MainThreadSerialDispatcher {
    private let executingCount = UnsafeMutablePointer<Int32>.allocate(capacity: 1)

    init() {
        executingCount.initialize(to: 0)
    }

    deinit {
        executingCount.deinitialize(count: 1)
        executingCount.deallocate()
    }

    func dispatch(_ action: @escaping () -> Void) {
        let count = OSAtomicIncrement32(executingCount)

        if Thread.isMainThread && count == 1 {
            action()
            OSAtomicDecrement32(executingCount)
        }
        else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }

                action()
                OSAtomicDecrement32(self.executingCount)
            }
        }
    }
}

import XCTest
@testable import DiffableDataSources

final class MainThreadSerialDispatcherTests: XCTestCase {
    func testMainThread() {
        let dispatcher = MainThreadSerialDispatcher()
        let queue = DispatchQueue.global()
        let expectation = self.expectation(description: "testMainThread")

        queue.async {
            dispatcher.dispatch {
                XCTAssertTrue(Thread.isMainThread)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testMainThreadSerial() {
        let dispatcher = MainThreadSerialDispatcher()
        let queue = DispatchQueue.global()
        let expectation = self.expectation(description: "testMainThreadSerial")

        var array = [Int]()

        let group = DispatchGroup()

        queue.async(group: group) {
            dispatcher.dispatch {
                array.append(0)
            }
        }

        group.wait()

        queue.async(group: group) {
            dispatcher.dispatch {
                array.append(1)
            }

            dispatcher.dispatch {
                array.append(2)
            }
        }

        group.wait()

        dispatcher.dispatch {
            array.append(3)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(array, [0, 1, 2, 3])
        }
    }
}

import XCTest
@testable import Wanderlist

final class WanderlistTests: XCTestCase {
    var store: WanderlistStore!

    override func setUp() {
        super.setUp()
        store = WanderlistStore()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.destinations.count, WanderlistStore.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.destinations.count
        let added = store.add(Destination(name: "D"), isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.destinations.count, before + 1)
    }

    func testAddRespectsFreeLimitWhenNotPro() {
        while store.destinations.count < WanderlistStore.freeTierLimit {
            _ = store.add(Destination(name: "D"), isPro: false)
        }
        let blocked = store.add(Destination(name: "D"), isPro: false)
        XCTAssertFalse(blocked)
    }

    func testProBypassesFreeLimit() {
        while store.destinations.count < WanderlistStore.freeTierLimit {
            _ = store.add(Destination(name: "D"), isPro: false)
        }
        let allowed = store.add(Destination(name: "D"), isPro: true)
        XCTAssertTrue(allowed)
    }

    func testCanAddReflectsLimit() {
        while store.destinations.count < WanderlistStore.freeTierLimit {
            _ = store.add(Destination(name: "D"), isPro: false)
        }
        XCTAssertFalse(store.canAdd(isPro: false))
        XCTAssertTrue(store.canAdd(isPro: true))
    }

    func testRemoveDecreasesCount() {
        _ = store.add(Destination(name: "D"), isPro: false)
        let before = store.destinations.count
        store.remove(at: IndexSet(integer: 0))
        XCTAssertEqual(store.destinations.count, before - 1)
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testPersistedStateRoundTrips() {
        let count = store.destinations.count
        let reloaded = WanderlistStore()
        XCTAssertEqual(reloaded.destinations.count, count)
    }
}

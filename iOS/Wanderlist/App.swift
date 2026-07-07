import SwiftUI

@main
struct WanderlistApp: App {
    @StateObject private var store = WanderlistStore()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .tint(Theme.accent)
        }
    }
}

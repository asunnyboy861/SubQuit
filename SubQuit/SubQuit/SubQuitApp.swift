import SwiftUI
import SwiftData

@main
struct SubQuitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Subscription.self)
    }
}

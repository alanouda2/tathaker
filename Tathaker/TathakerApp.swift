import SwiftUI
import Firebase

@main
struct TathakerApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            TicketSplashView()
        }
    }
}

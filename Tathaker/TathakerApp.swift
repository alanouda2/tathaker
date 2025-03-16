import SwiftUI
import Firebase
import FirebaseAuth

@main
struct TathakerApp: App {
    @State private var isUserLoggedIn = false // Track authentication state
    @StateObject private var userViewModel = UserViewModel() // ✅ Create global instance


    init() {
        FirebaseApp.configure()
        checkUserLoginStatus() // Check if user is logged in
    }

    var body: some Scene {
        WindowGroup {
            if isUserLoggedIn {
                MainTabView() // ✅ Show Home, Tickets, Profile
                    .environmentObject(userViewModel) // ✅ Inject ViewModel in root

            } else {
                TicketSplashView().environmentObject(userViewModel) // ✅ Show login/signup
            }
        }
    }

    // ✅ Check if user is logged in
    private func checkUserLoginStatus() {
        DispatchQueue.main.async {
            self.isUserLoggedIn = Auth.auth().currentUser != nil
        }
    }
}

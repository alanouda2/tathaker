import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainTabView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }

            LoginView()
                .tabItem {
                    Image(systemName: "ticket.fill")
                    Text("Tickets")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(Color.customDarkBlue) // ✅ Tab bar icon & text color
        .background(Color.customDarkBlue.edgesIgnoringSafeArea(.bottom)) // ✅ Dark blue background
    }
}

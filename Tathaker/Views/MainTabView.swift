import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Ensure global user state

    var body: some View {
        TabView(selection: $selectedTab) {
            EventListView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            TicketsView()
                .tabItem {
                    Image(systemName: "ticket.fill")
                    Text("Tickets")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(Color(red: 35/255, green: 56/255, blue: 84/255)) // ✅ Dark blue tab highlight
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView().environmentObject(UserViewModel()) // ✅ Inject ViewModel
    }
}

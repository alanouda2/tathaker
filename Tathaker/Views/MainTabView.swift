import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MainTabView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var nav: NavigationCoordinator
    @State private var homePath = NavigationPath()
    
    @State private var homeTabId = UUID()
  

    var body: some View {
        TabView(selection: $nav.selectedTab) {
            NavigationStack(path: $homePath) {
                EventListView()
            }
            .id(homeTabId) // 🔥 Force rebuild
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)

            NavigationStack {
                TicketsView()
                    .environmentObject(userViewModel)
            }
            .tabItem {
                Image(systemName: "ticket.fill")
                Text("Tickets")
            }
            .tag(1)
            NavigationStack
                {
                   ResellTicketsView()
               }
               .tabItem {
                   Image(systemName: "arrow.2.squarepath") // or another icon like "repeat"
                   Text("Resell")
               }
               .tag(2)

            NavigationStack {
                ProfileView()
                    .environmentObject(userViewModel)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(3)
            
            
        }
       
        .accentColor(Color(red: 35/255, green: 56/255, blue: 84/255))
        .onAppear() {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor(Color(hex: "#2A4D69"))
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
            
           
        }
        .sheet(item: $nav.ticketConfirmationData, onDismiss: {
            DispatchQueue.main.async {
                nav.selectedTab = 0
                homePath = NavigationPath()              // Clear navigation
                homeTabId = UUID()                       // 💥 Rebuild the stack
            }
        }) { event in
            TicketConfirmationView(event: event)
        }
    }
}


//struct MainTabView_Previews: PreviewProvider {
    //static var previews: some View {
        //MainTabView().environmentObject(UserViewModel()) // ✅ Inject ViewModel
    //}
//}

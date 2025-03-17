import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Ensure global user state

    var body: some View {
        TabView {
            EventListView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            TicketsView()
                .environmentObject(userViewModel) // ✅ Use same instance
                .tabItem {
                    Image(systemName: "ticket.fill")
                    Text("Tickets")
                }

            ProfileView()
                .environmentObject(userViewModel) // ✅ Use same instance
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(Color(red: 35/255, green: 56/255, blue: 84/255)) // ✅ Dark blue tab highlight
        .navigationBarBackButtonHidden(true) // ✅ Hide default back button

    }
}


//struct MainTabView_Previews: PreviewProvider {
    //static var previews: some View {
        //MainTabView().environmentObject(UserViewModel()) // ✅ Inject ViewModel
    //}
//}

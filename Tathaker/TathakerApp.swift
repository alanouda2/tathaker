import SwiftUI
import Firebase
import FirebaseAuth

@main
struct TathakerApp: App {
   
    @StateObject private var userViewModel = UserViewModel() // ✅ Create global instance
    @StateObject var nav = NavigationCoordinator.shared
    
    

    init() {
        FirebaseApp.configure()
        self.userViewModel.checkUserStatus() // Check if user is logged in
        
       
            
            // Consistent tab bar appearance
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(named: "TabBarBackground") ?? UIColor.white
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
    }

    var body: some Scene {
        WindowGroup {
            if userViewModel.isLoggedIn {
               
                    MainTabView() // ✅ Show Home, Tickets, Profile
                        .environmentObject(userViewModel) // ✅ Inject ViewModel in root
                        .environmentObject(nav)
                
                

            } else if userViewModel.isGuest {
                
                Guest_MainView() // ✅ Show Home, Tickets, Profile
                    .environmentObject(userViewModel) // ✅ Inject ViewModel in root
            

        }else {
                TicketSplashView().environmentObject(userViewModel) // ✅ Show login/signup
            }
        }
    }

 
}

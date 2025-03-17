//
//  Guest_Main.swift
//  Tathaker
//
//  Created by Bullshit  on 17/03/2025.
//
import SwiftUI

struct Guest_MainView: View {
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Ensure global user state

    var body: some View {
        TabView {
            Guest_EventListView().environmentObject(userViewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            GuestView()
                .environmentObject(userViewModel) // ✅ Use same instance
                .tabItem {
                    Image(systemName: "ticket.fill")
                    Text("Tickets")
                }

            GuestView()
                .environmentObject(userViewModel) // ✅ Use same instance
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(Color(red: 35/255, green: 56/255, blue: 84/255)) // ✅ Dark blue tab highlight
    }
}

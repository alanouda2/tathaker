//
//  Guest_Main.swift
//  Tathaker
//
//  Created by Bullshit  on 17/03/2025.
//
import SwiftUI

struct Guest_MainView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var tabRouter: TabRouter

    var body: some View {
        TabView {
            NavigationStack {
                EventListView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NavigationStack {
                GuestView()
                    .environmentObject(userViewModel)
            }
            .tabItem {
                Image(systemName: "ticket.fill")
                Text("Tickets")
                    
            }
            
            NavigationStack {
                GuestView()
               }
               .tabItem {
                   Image(systemName: "arrow.2.squarepath") // or another icon like "repeat"
                   Text("Resell")
               }

            NavigationStack {
                GuestView()
                    .environmentObject(userViewModel)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            
            
        }
        .accentColor(Color(red: 35/255, green: 56/255, blue: 84/255))
    }
}


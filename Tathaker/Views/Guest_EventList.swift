//
//  Guest_Event.swift
//  Tathaker
//
//  Created by Bullshit  on 17/03/2025.
//
import SwiftUI
import Firebase

struct Guest_EventListView: View {
    @ObservedObject var viewModel = EventViewModel()
    @State private var searchText = ""
    @EnvironmentObject var userViewModel: UserViewModel
    

    let categories = [
        Category(name: "Concerts", iconName: "music.note"),
        Category(name: "Sports", iconName: "sportscourt"),
        Category(name: "Theater", iconName: "theatermasks"),
        Category(name: "Markets", iconName: "cart")
    ]
    
    var filteredEvents: [Event] {
        if searchText.isEmpty {
            return viewModel.events
        } else {
            return viewModel.events.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.location.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                ZStack (alignment: .top){
                    // ✅ Full-width Dark Blue Background
                    Color(red: 35/255, green: 56/255, blue: 84/255)
                        .frame(height: 120) // Adjust height to make it cover the top properly
                        .ignoresSafeArea(edges: .top) // ⬅ Ensure it reaches the top
                        .ignoresSafeArea(.all)

                    // ✅ Centered Tathaker Logo
                    Image("Tathaker")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 128) // ⬅ Adjust logo size
                        .offset(y: -35) // ⬅ Move it up slightly
                }
                .frame(maxWidth: .infinity)
                .padding(.top, -10)

                // ✅ Reduce space between the header and search bar
                .padding(.bottom, -40) // Adjust negative padding to bring the search bar closer

                VStack {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search by Event or Location", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(categories) { category in
                                CategoryIcon(category: category)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                    
                    // ✅ "You might like..." Section
                    HStack {
                        Text("You might like...")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.top, 5)

                    // ✅ Event List (Cards same width as Search Bar)
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(filteredEvents) { event in
                                NavigationLink(destination: Guest_EventDetailsView(event: event)) {
                                    Guest_EventCard(event: event)
                                        .frame(maxWidth: UIScreen.main.bounds.width + 60)                                         .padding(.horizontal, 16) // ⬅ Same as search bar
                                }
                            }
                        }
                        .padding(.top, 5)
                    }
                    
                    Spacer()
                } // <-- MISSING BRACKET ADDED HERE
            }
            .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.fetchEvents()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

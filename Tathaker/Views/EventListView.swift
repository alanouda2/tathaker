import SwiftUI
import Firebase

struct EventListView: View {
    @ObservedObject var viewModel = EventViewModel()
    @State private var searchText = ""
    @State private var selectedTab: Int = 0 // Track selected tab

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
                        .frame(height: 120)
                        .ignoresSafeArea(edges: .top)
                        .ignoresSafeArea(.all)

                    // ✅ Centered Tathaker Logo
                    Image("Tathaker")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .offset(y: -20)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, -10)
                .padding(.bottom, -40)

                if selectedTab == 0 {  // ✅ Home (Event List)
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

                        // Event List
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(filteredEvents) { event in
                                    NavigationLink(destination: EventDetailView(event: event)) {
                                        EventCard(event: event)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                } else if selectedTab == 1 {  // ✅ Tickets Tab
                    TicketsView()
                } else if selectedTab == 2 {  // ✅ Profile Tab
                    ProfileView()
                }

                // ✅ Bottom Tab Bar
                HStack {
                    Button(action: { selectedTab = 0 }) {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: { selectedTab = 1 }) {
                        VStack {
                            Image(systemName: "ticket.fill")
                            Text("Tickets")
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: { selectedTab = 2 }) {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 5)
            }
            .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.fetchEvents()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

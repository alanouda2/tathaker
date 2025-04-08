import SwiftUI
import Firebase
import FirebaseAuth

struct TicketsView: View {
    @State private var selectedTab = "Upcoming"
    @State private var upcomingTickets: [BookedTicket] = []
    @State private var historyTickets: [BookedTicket] = []
    let userID = Auth.auth().currentUser?.uid ?? "guest"

    var body: some View {
        NavigationStack {
            ZStack
            {
                Color(hex: "#2A4D69").ignoresSafeArea()
                VStack {
                    // 🔘 Tab Toggle
                    HStack(spacing: 16) {
                        Button(action: { selectedTab = "Upcoming" }) {
                            Text("Upcoming")
                                .foregroundColor(selectedTab == "Upcoming" ? .white : .black)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 24)
                                .background(selectedTab == "Upcoming" ? Color(hex: "#1B365D") : Color.white)
                                .cornerRadius(20)
                        }
                        
                        Button(action: { selectedTab = "History" }) {
                            Text("History")
                                .foregroundColor(selectedTab == "History" ? .white : .black)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 24)
                                .background(selectedTab == "History" ? Color(hex: "#1B365D") : Color.white)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.top)
                    .background(Color(hex: "#2A4D69"))
                    
                    // 🧾 Ticket Cards
                    if currentTickets.isEmpty {
                        Spacer()
                        Text("No tickets found.")
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        TabView {
                            ForEach(currentTickets) { ticket in
                                TicketCardView(ticket: ticket)
                                    .padding(.horizontal)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .frame(height: 500)
                    }
                    
                    Spacer()
                }
                .navigationTitle("My Tickets")
                .navigationBarTitleDisplayMode(.inline)
                
                .onAppear {
                    fetchTickets()
                    
                    
                    let navBarAppearance = UINavigationBarAppearance()
                    navBarAppearance.configureWithOpaqueBackground()
                    navBarAppearance.backgroundColor = UIColor(Color(hex: "#2A4D69"))
                    navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                    
                    UINavigationBar.appearance().standardAppearance = navBarAppearance
                    UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
                    
                }
            }
        }
    }

    var currentTickets: [BookedTicket] {
        selectedTab == "Upcoming" ? upcomingTickets : historyTickets
    }

    // 📥 Firestore Fetch
    private func fetchTickets() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let now = Timestamp(date: Date())
        
        db.collection("users").document(userId).collection("bookings")
            //.whereField("eventDate", isLessThan: now)
            //.order(by: "eventDate", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching history: \(error.localizedDescription)")
                   
                    return
                }
                
                var fetchedTickets: [BookedTicket] = []
                
                snapshot?.documents.forEach { doc in
                    let data = doc.data()
                    let eventId = data["eventId"] as? String ?? ""
                    let eventTitle = data["eventTitle"] as? String ?? "Unknown Event"
                    let quantity = data["quantity"] as? Int ?? 1
                    let bookingTime = (data["bookingTime"] as? String ?? "")
                    let eventDate = (data["eventDate"] as? Date ?? Date())
                    
                    let ticket = BookedTicket(
                        id: doc.documentID,
                        eventId: eventId,
                        eventTitle: eventTitle,
                        eventDate: eventDate,
                        quantity: quantity,
                        bookingTime: bookingTime
                    )
                    
                    fetchedTickets.append(ticket)
                }
                
                self.upcomingTickets = fetchedTickets
                self.historyTickets = fetchedTickets
               // self.isLoading = false
            }
    }
}

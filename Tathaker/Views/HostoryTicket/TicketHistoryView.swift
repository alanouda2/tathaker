//
//  TicketHistoryView.swift
//  Tathaker
//
//  Created by Muhammad Zakir on 30/03/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct BookedTicket: Identifiable {
    var id: String
    var eventId: String
    var eventTitle: String
    var eventDate: Date
    var quantity: Int
    var bookingTime: String
    var imageUrl: String
    var resellPrice: Double
    
//    init(id: String, data: [String: Any]) {
//        self.id = id// Generates a unique ID
//        self.eventTitle = data["eventTitle"] as? String ?? "Unknown Event"
//        self.bookingTime = data["eventDate"] as? String ?? "Unknown Date"
//        self.eventId = data["eventID"] as? String ?? ""
//        self.quantity = data["quantity"] as? Int ?? 1
//    }
}



struct TicketHistoryView: View {
    @State private var selectedTab = "History"
    @State private var upcomingTickets: [BookedTicket] = []
    @State private var historyTickets: [BookedTicket] = []
    let userID = Auth.auth().currentUser?.uid ?? "guest"
    
    @Environment(\.dismiss) var dismiss

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
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    // 🔙 Back Button
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .imageScale(.large)
                            }
                        }
                    
                    ToolbarItem(placement: .principal) {
                        Text("My Tickets")
                            .font(.custom("PoetsenOne-Regular", size: 28))
                            .foregroundColor(.white)
                    }
                }
                
                .onAppear {
                    fetchTickets()
                    
                    
                   
                    
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
        let now = Date()

        db.collection("users").document(userId).collection("bookings")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching history: \(error.localizedDescription)")
                    return
                }

                var upcoming: [BookedTicket] = []
                var history: [BookedTicket] = []

                snapshot?.documents.forEach { doc in
                    let data = doc.data()
                    let eventId = data["eventId"] as? String ?? ""
                    let eventTitle = data["eventTitle"] as? String ?? "Unknown Event"
                    let quantity = data["quantity"] as? Int ?? 1
                    let bookingTime = (data["bookingTime"] as? String ?? "")
                    let eventDate = (data["eventDate"] as? Date ?? Date())
                    let imageUrl = (data["imageUrl"] as? String ?? "")
                    let resellPrice = (data["resellPrice"] as? Double ?? 0)

                    let ticket = BookedTicket(
                        id: doc.documentID,
                        eventId: eventId,
                        eventTitle: eventTitle,
                        eventDate: eventDate,
                        quantity: quantity,
                        bookingTime: bookingTime,
                        imageUrl: imageUrl,
                        resellPrice: resellPrice
                    )

                    if eventDate >= now {
                        upcoming.append(ticket)
                    } else {
                        history.append(ticket)
                    }
                }

                
                self.upcomingTickets = upcoming.sorted(by: { $0.eventDate < $1.eventDate })
                self.historyTickets = history.sorted(by: { $0.eventDate > $1.eventDate })
            }
    }
}

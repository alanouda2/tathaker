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
    
//    init(id: String, data: [String: Any]) {
//        self.id = id// Generates a unique ID
//        self.eventTitle = data["eventTitle"] as? String ?? "Unknown Event"
//        self.bookingTime = data["eventDate"] as? String ?? "Unknown Date"
//        self.eventId = data["eventID"] as? String ?? ""
//        self.quantity = data["quantity"] as? Int ?? 1
//    }
}

struct TicketHistoryView: View {
    @State private var pastTickets: [BookedTicket] = []
    @State private var isLoading = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text("Back")
                                .foregroundColor(.blue)
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                
                if isLoading {
                    ProgressView("Fetching Tickets...")
                } else if pastTickets.isEmpty {
                    Text("No past tickets found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(pastTickets) { ticket in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(ticket.eventTitle)
                                .font(.headline)
                            Text("Date & Time: \(ticket.bookingTime)")
                            Text("Tickets: \(ticket.quantity)")
                        }
                        .padding(.vertical, 5)
                    }
                    
                }
            }
            .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
            .navigationTitle("Ticket History")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchPastTickets()
            }
        }
    }
    
    private func fetchPastTickets() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let now = Timestamp(date: Date())
        
        db.collection("users").document(userId).collection("bookings")
            //.whereField("eventDate", isLessThan: now)
            //.order(by: "eventDate", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching history: \(error.localizedDescription)")
                    isLoading = false
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
                
                self.pastTickets = fetchedTickets
                self.isLoading = false
            }
    }
}


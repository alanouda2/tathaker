//
//  ResellTicketsView.swift
//  Tathaker
//
//  Created by Muhammad Zakir on 06/04/2025.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct ResellTicketsView: View {
    @State private var myTickets: [BookedTicket] = []
    @State private var selectedPrice: String = ""
    let userID = Auth.auth().currentUser?.uid ?? "guest"

    var body: some View {
        NavigationStack {
            VStack {
                Text("List Your Ticket for Resale")
                    .font(.headline)
                    .padding()

                if myTickets.isEmpty {
                    Text("No eligible tickets found.")
                        .foregroundColor(.gray)
                } else {
                    List(myTickets) { ticket in
                                           VStack(alignment: .leading, spacing: 4) {
                                               Text(ticket.eventTitle)
                                                   .font(.headline)
                                               Text("Date: \(ticket.eventDate)")
                                               //Text("Location: \(ticket.eventLocation)")

                                               TextField("Enter resale price", text: $selectedPrice)
                                                   .keyboardType(.numberPad)
                                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                                   .padding(.vertical, 4)

                                               Button("List for Resell") {
                                                   listTicketForResale(ticket, price: selectedPrice)
                                               }
                                               .foregroundColor(.blue)
                                           }
                                           .padding(.vertical, 6)
                                       }
                }
                Spacer()
            }
            .padding()
            .onAppear {
                fetchUserTickets()
            }
            .navigationTitle("Resell Tickets")
        }
    }

    func fetchUserTickets() {
        let db = Firestore.firestore()
        let today = Date()

        db.collection("tickets")
            .whereField("userID", isEqualTo: userID)
            .whereField("isResell", isEqualTo: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching tickets: \(error)")
                    return
                }

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"

                self.myTickets = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    
                    guard
                        let eventID = data["eventID"] as? String,
                        let eventTitle = data["eventTitle"] as? String,
                        let eventDateStr = data["eventDate"] as? String,
                        let quantity = data["quantity"] as? Int,
                        let eventDate = formatter.date(from: eventDateStr),
                        eventDate > today
                    else {
                        return nil
                    }

                    return BookedTicket(
                        id: doc.documentID,
                        eventId: eventID,
                        eventTitle: eventTitle,
                        eventDate: eventDate,
                        quantity: quantity,
                        bookingTime: eventDateStr // keep as string
                    )
                } ?? []
            }
    }


    func listTicketForResale(_ ticket: BookedTicket, price: String) {
        let db = Firestore.firestore()
        guard let priceValue = Double(price) else { return }

        db.collection("tickets").document(ticket.id).updateData([
            "isResell": true,
            "resellPrice": priceValue,
            "resellListedAt": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error listing ticket: \(error)")
            } else {
                print("✅ Ticket listed for resale")
                fetchUserTickets()
            }
        }
    }
}


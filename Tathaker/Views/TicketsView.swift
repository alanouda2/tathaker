import SwiftUI
import Firebase
import FirebaseAuth


struct TicketsView: View {
    @State private var tickets: [Ticket] = []
    let userID = Auth.auth().currentUser?.uid ?? "guest" // ✅ Fixed Auth Scope

    var body: some View {
        VStack {
            Text("Your Tickets")
                .font(.largeTitle)
                .bold()
                .padding()

            if tickets.isEmpty {
                Text("No current tickets")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    ForEach(tickets) { ticket in
                        VStack {
                            Text(ticket.eventTitle)
                                .font(.headline)

                            Text(ticket.eventDate)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            AsyncImage(url: URL(string: ticket.ticketQR)) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .padding()

                        Divider()
                    }
                }
            }
        }
        .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchTickets()
        }
    }

    // ✅ Fetch Tickets from Firestore
    func fetchTickets() {
        let db = Firestore.firestore()
        db.collection("tickets").whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching tickets: \(error)")
                return
            }

            DispatchQueue.main.async {
                self.tickets = snapshot?.documents.compactMap { doc -> Ticket? in
                    return Ticket(id: doc.documentID, data: doc.data())
                } ?? []
            }
        }
    }
}

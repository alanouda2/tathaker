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
    @State private var selectedTab = "Sell"

    @State private var myTickets: [BookedTicket] = []
    @State private var resaleMarket: [BookedTicket] = []
    @State private var priceInputs: [String: String] = [:]

    let userID = Auth.auth().currentUser?.uid ?? "guest"
    
    @State private var ticketSellerMap: [String: String] = [:]
    
    @State private var selectedTicket: BookedTicket?
    @State private var selectedSellerId: String?
    @State private var selectedTicketId: String?

    var body: some View {
        NavigationStack {
            
            
            
            VStack {
                Picker("Mode", selection: $selectedTab) {
                    Text("Sell").tag("Sell")
                    Text("Buy").tag("Buy")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedTab) { oldValue, newValue in
                    fetchUserTickets()
                    fetchResellMarket()
                }

                if selectedTab == "Sell" {
                    sellView
                } else {
                    buyView
                }
                
                Spacer()
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Resell Tickets")
                        .font(.custom("PoetsenOne-Regular", size: 28))
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        selectedTicket = nil
                        selectedTicketId = nil
                        selectedSellerId = nil
                    }
                fetchUserTickets()
                fetchResellMarket()
                    
                       
                    
            }
            
            
                NavigationLink(
                    tag: selectedTicket?.id ?? "",
                    selection: $selectedTicketId
                ) {
                    if let ticket = selectedTicket,
                       let sellerId = selectedSellerId {
                        MyFakePaymentView(ticket: ticket, sellerId: sellerId)
                            .navigationBarBackButtonHidden()
                    }
                } label: {
                    EmptyView()
                }
                .hidden()
            
        }
    }

    // MARK: Sell View
    var sellView: some View {
        VStack {
            if myTickets.isEmpty {
                Text("No eligible tickets found.")
                    .foregroundColor(.gray)
            } else {
                List(myTickets) { ticket in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 12) {
                            AsyncTicketImage(url: ticket.imageUrl)

                            VStack(alignment: .leading) {
                                Text(ticket.eventTitle)
                                    .font(.subheadline)
                                Text("Date: \(ticket.bookingTime)")
                                    .font(.footnote)
                            }
                        }

                        TextField("Enter resale price", text: Binding(
                            get: { priceInputs[ticket.id] ?? "" },
                            set: { priceInputs[ticket.id] = $0 }
                        ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button("List for Resell") {
                            listTicketForResale(ticket, price: priceInputs[ticket.id] ?? "")
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: Buy View
    var buyView: some View {
       
        VStack {
            if resaleMarket.isEmpty {
                Text("No tickets currently listed for resale.")
                    .foregroundColor(.gray)
                
            } else {
                List(resaleMarket) { ticket in
                    HStack(spacing: 12) {
                        AsyncTicketImage(url: ticket.imageUrl)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(ticket.eventTitle).font(.subheadline)
                            Text("Date: \(ticket.bookingTime)").font(.footnote)
                            Text("Price: QR \(String(format: "%.2f", ticket.resellPrice ?? 0.0))")
                                .font(.footnote)
                                .foregroundColor(.green)
                        }

                        Spacer()
                        Button("Buy") {
                            // TODO: Implement transfer/purchase logic
                            print("🛒 Buying ticket: \(ticket.id)")
                            
                            selectedTicket = ticket
                                selectedSellerId = findSellerId(for: ticket)
                                selectedTicketId = ticket.id // ✅ triggers NavigationLink with tag
                            
                        }
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.green)
                        .cornerRadius(6)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .padding(.horizontal)
        
        
        
        
    }

    // MARK: Fetch User Tickets (Sell Tab)
    func fetchUserTickets() {
        let db = Firestore.firestore()
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        db.collection("users").document(userID).collection("bookings")
            .whereField("isResell", isEqualTo: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching tickets: \(error)")
                    return
                }

                self.myTickets = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    guard
                        let eventID = data["eventId"] as? String,
                        let eventTitle = data["eventTitle"] as? String,
                        let bookingTime = data["bookingTime"] as? String,
                        let quantity = data["quantity"] as? Int,
                        let date = formatter.date(from: bookingTime),
                        let imageUrl = data["imageUrl"] as? String,
                        date > today
                    else {
                        return nil
                    }

                    return BookedTicket(
                        id: doc.documentID,
                        eventId: eventID,
                        eventTitle: eventTitle,
                        eventDate: date,
                        quantity: quantity,
                        bookingTime: bookingTime,
                        imageUrl: imageUrl,
                        resellPrice: 0
                    )
                } ?? []
            }
    }
    
    

    func fetchResellMarket() {
        let db = Firestore.firestore()
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        db.collection("users").getDocuments { userSnapshot, error in
            if let error = error {
                print("❌ Error fetching users: \(error)")
                return
            }

            guard let userDocs = userSnapshot?.documents else {
                print("⚠️ No user documents found")
                return
            }

            var allTickets: [BookedTicket] = []
            let group = DispatchGroup()

            for userDoc in userDocs {
                
                guard !userDoc.data().isEmpty else {
                       print("⚠️ Skipping empty user doc: \(userDoc.documentID)")
                       continue
                   }

                
                let userId = userDoc.documentID
                
                if userId == Auth.auth().currentUser?.uid {
                       print("🙅‍♂️ Skipping logged-in user: \(userId)")
                       continue
                   }
                
                group.enter()

                let bookingsRef = db.collection("users").document(userId).collection("bookings")
                bookingsRef.getDocuments { bookingSnapshot, error in
                    defer { group.leave() }

                    guard let docs = bookingSnapshot?.documents, !docs.isEmpty else {
                        print("🕳 No bookings found for user: \(userId)")
                        return
                    }

                    let tickets = docs.compactMap { doc -> BookedTicket? in
                        let data = doc.data()

                        guard
                            let isResell = data["isResell"] as? Bool, isResell == true,
                            let eventID = data["eventId"] as? String,
                            let eventTitle = data["eventTitle"] as? String,
                            let bookingTime = data["bookingTime"] as? String,
                            let resellPrice = data["resellPrice"] as? Double
                        else {
                            print("⛔️ Skipping booking \(doc.documentID) — missing or invalid required fields")
                            return nil
                        }

                        let quantity = data["quantity"] as? Int ?? 1
                        let imageUrl = data["imageUrl"] as? String ?? ""

                        guard let date = formatter.date(from: bookingTime), date > today else {
                            print("⏱ Skipping expired or invalid date in \(doc.documentID)")
                            return nil
                        }

                        let ticket = BookedTicket(
                            id: doc.documentID,
                            eventId: eventID,
                            eventTitle: eventTitle,
                            eventDate: date,
                            quantity: quantity,
                            bookingTime: bookingTime,
                            imageUrl: imageUrl,
                            resellPrice: resellPrice
                        )
                        
                        // 🧠 Track ticket to seller
                        DispatchQueue.main.async {
                            self.ticketSellerMap[ticket.id] = userId
                        }
                        
                        return ticket
                    }

                    allTickets.append(contentsOf: tickets)
                }
            }

            group.notify(queue: .main) {
                self.resaleMarket = allTickets
                print("✅ Final resale tickets loaded: \(allTickets.count)")
            }
        }
    }


    func findSellerId(for ticket: BookedTicket) -> String? {
        return ticketSellerMap[ticket.id]
    }

    // MARK: Resell Logic
    func listTicketForResale(_ ticket: BookedTicket, price: String) {
        let db = Firestore.firestore()
        guard let priceValue = Double(price), priceValue > 0 else { return }

        db.collection("users").document(userID).collection("bookings").document(ticket.id).updateData([
            "isResell": true,
            "resellPrice": priceValue
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

// MARK: Helper Image View
struct AsyncTicketImage: View {
    let url: String

    var body: some View {
        if let imageURL = URL(string: url.trimmingCharacters(in: .whitespacesAndNewlines)) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(6)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .cornerRadius(6)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
                .cornerRadius(6)
        }
    }
}

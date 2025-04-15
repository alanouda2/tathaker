
import SwiftUI
import Firebase
import FirebaseAuth

struct MyFakePaymentView: View {
    
    @State private var selectedPaymentMethod = "Credit Card"
    @State private var selectedCardIndex = 0
    @State private var userName = "Guest User"
    @State private var navigateToConfirmation = false
    @State private var quantity = "1"
    @FocusState private var isQuantityFocused: Bool
    
    let ticket: BookedTicket
        let sellerId: String
    
    @State private var isProcessing = false
        @State private var showSuccess = false
    
    @Environment(\.dismiss) var dismiss

    let basePrice = 50

    let userCards: [Card] = [
        Card(bank: "QNB", type: "CREDIT", number: "0000 2363 8364 8269", expiry: "5/25", cvv: "633", provider: "VISA"),
        Card(bank: "QIB", type: "DEBIT", number: "**** **** **** 1234", expiry: "7/26", cvv: "789", provider: "MASTERCARD")
    ]

    var totalAmount: Int {
        let qty = Int(quantity) ?? 1
        return basePrice * qty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#2A4D69").ignoresSafeArea()

                VStack(alignment: .leading, spacing: 15) {
                    Text("Payment options")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.horizontal)

                    HStack(spacing: 20) {
                        PaymentMethodIcon(systemName: "creditcard.fill", isSelected: selectedPaymentMethod == "Credit Card")
                            .onTapGesture { selectedPaymentMethod = "Credit Card" }

                        PaymentMethodIcon(imageName: "paypal", isSelected: selectedPaymentMethod == "PayPal")
                            .onTapGesture { selectedPaymentMethod = "PayPal" }

                        PaymentMethodIcon(imageName: "applepay", isSelected: selectedPaymentMethod == "Apple Pay")
                            .onTapGesture { selectedPaymentMethod = "Apple Pay" }
                    }
                    .padding(.horizontal)

                    Text("Select your card")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(userCards.indices, id: \ .self) { index in
                                PaymentCardView(card: userCards[index], isSelected: index == selectedCardIndex, userName: userName)
                                    .onTapGesture {
                                        selectedCardIndex = index
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading) {
                        Text("Select Quantity")
                            .font(.headline)
                            .foregroundColor(.white)

                        HStack {
                            Button(action: {
                                let currentQty = Int(quantity) ?? 1
                                if currentQty > 1 {
                                    quantity = "\(currentQty - 1)"
                                }
                                isQuantityFocused = false
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .disabled(true)

                            TextField("Quantity", text: Binding.constant("1"))
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 50)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($isQuantityFocused)
                                

                            Button(action: {
                                let currentQty = Int(quantity) ?? 1
                                quantity = "\(currentQty + 1)"
                                isQuantityFocused = false
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .disabled(true)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 5) {
                        SummaryRow(title: "Custom bag", price: "\(ticket.resellPrice) QAR", isBold: false)
                        Divider().background(Color.white.opacity(0.5))
                        SummaryRow(title: "Total amount", price: "\(ticket.resellPrice) QAR", isBold: true)
                    }
                    .padding()
                    .background(Color(hex: "#2A4D69").opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Button(action: {
                        buyResellTicket()
                        
                    }) {
                        Text("Book Tickets")
                            .foregroundColor(.white)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#1B365D"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: MyTicketConfirmationView(ticket: self.ticket, openHome: Binding.constant(false)), isActive: $navigateToConfirmation) {
                        EmptyView()
                    }
                }
                .onAppear {
                    fetchUserName()
                    
                }
            }
            .toolbarBackground(Color(hex: "#2A4D69"), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isQuantityFocused = false
                        navigateToConfirmation = false
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white)
                        .onTapGesture(perform: {
                            shareEvent()
                        })
                }
            }
        }
        .onTapGesture {
            isQuantityFocused = false
        }
    }
    
    
    private func buyResellTicket() {
            guard let buyerId = Auth.auth().currentUser?.uid else { return }

            isProcessing = true
            let db = Firestore.firestore()

            // 1. Save ticket in buyer's bookings
            let booking: [String: Any] = [
                "eventId": ticket.eventId,
                "eventTitle": ticket.eventTitle,
                "eventDate": ticket.eventDate,
                "quantity": ticket.quantity,
                "bookingTime": ticket.eventDate,
                "imageUrl": ticket.imageUrl,
                "resellPrice": ticket.resellPrice,
                "isResell": false
            ]

            db.collection("users").document(buyerId).collection("bookings")
                .addDocument(data: booking) { error in
                    if let error = error {
                        print("❌ Error saving to buyer: \(error)")
                        isProcessing = false
                        return
                    }

                    // 2. Delete original ticket from seller
                    db.collection("users").document(sellerId).collection("bookings")
                        .document(ticket.id)
                        .delete { err in
                            isProcessing = false
                            if let err = err {
                                print("❌ Error deleting seller's ticket: \(err)")
                            } else {
                                showSuccess = true
                                navigateToConfirmation = true
                            }
                        }
                }
        }
    
    private func shareEvent() {
        let text = "Check out this event: \(ticket.eventTitle) at \(ticket.eventDate)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }

    private func fetchUserName() {
        if let user = Auth.auth().currentUser {
            userName = user.displayName ?? "Guest User"
        }
    }
}

// Card, PaymentMethodIcon, PaymentCardView, SummaryRow remain unchanged...








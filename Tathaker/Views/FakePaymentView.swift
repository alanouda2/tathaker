import SwiftUI
import Firebase
import FirebaseAuth

struct FakePaymentView: View {
    let event: Event
    @State private var selectedPaymentMethod = "Credit Card"
    @State private var selectedCardIndex = 0
    @State private var userName = "Guest User"
    @State private var navigateToConfirmation = false
    @State private var quantity = "1"
    @FocusState private var isQuantityFocused: Bool
    
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
    
    @Binding var openHome : Bool

    var body: some View {
        
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

                            TextField("Quantity", text: $quantity)
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
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 5) {
                        SummaryRow(title: "Custom bag", price: "\(basePrice * (Int(quantity) ?? 1))QAR", isBold: false)
                        Divider().background(Color.white.opacity(0.5))
                        SummaryRow(title: "Total amount", price: "\(totalAmount)QAR", isBold: true)
                    }
                    .padding()
                    .background(Color(hex: "#2A4D69").opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Button(action: {
                        isQuantityFocused = false
                        let db = Firestore.firestore()
                        guard let userId = Auth.auth().currentUser?.uid else { return }

                        let bookingData: [String: Any] = [
                            "eventId": event.id,
                            "eventTitle": event.title,
                            "quantity": Int(quantity) ?? 1,
                            "bookingTime": event.date,
                            "isResell": false,
                            "imageUrl": event.imageUrl ?? ""
                        ]

                        db.collection("users").document(userId).collection("bookings").addDocument(data: bookingData) { error in
                            if let error = error {
                                print("❌ Error saving booking: \(error.localizedDescription)")
                            } else {
                                print("✅ Booking saved successfully")
                                //navigateToConfirmation = true
                               
                                
                                NavigationCoordinator.shared.ticketConfirmationData = event
                                 // Switch to Home tab
                               
                              
                                    NavigationCoordinator.shared.selectedTab = 0
                            
                                
                            }
                        }
                        
                        
                        let earnedPoints = (Int(quantity) ?? 1) * 10  // 10 points per ticket

                        db.collection("users").document(userId).updateData([
                            "totalPoints": FieldValue.increment(Int64(earnedPoints))
                        ]) { err in
                            if let err = err {
                                print("❌ Error updating points: \(err)")
                            } else {
                                print("✅ Points updated")
                            }
                        }
                        
                        
                        
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

//                    NavigationLink(destination: TicketConfirmationView(event: event), isActive: $navigateToConfirmation) {
//                        EmptyView()
//                    }
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
        .onTapGesture {
            isQuantityFocused = false
        }
    }
    
    private func shareEvent() {
        let text = "Check out this event: \(event.title) at \(event.location)"
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




// ✅ Structs for Payment Card & Methods
struct Card {
    let bank: String
    let type: String
    let number: String
    let expiry: String
    let cvv: String
    let provider: String
}

struct PaymentMethodIcon: View {
    let systemName: String?
    let imageName: String?
    let isSelected: Bool
    
    init(systemName: String, isSelected: Bool) {
        self.systemName = systemName
        self.imageName = nil
        self.isSelected = isSelected
    }
    
    init(imageName: String, isSelected: Bool) {
        self.systemName = nil
        self.imageName = imageName
        self.isSelected = isSelected
    }
    
    var body: some View {
        Group {
            if let systemName = systemName {
                Image(systemName: systemName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(isSelected ? .blue : .gray)
            } else if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .frame(width: 50, height: 30)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
        .padding()
        .background(isSelected ? Color.white.opacity(0.2) : Color.clear)
        .cornerRadius(10)
    }
}

// ✅ Payment Card View
struct PaymentCardView: View {
    let card: Card
    let isSelected: Bool
    let userName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(card.bank)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Text(card.type)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Text(card.number)
                .font(.title3)
                .foregroundColor(.white)
                .bold()
            
            HStack {
                Text("VALID THRU \(card.expiry)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                Text(card.cvv)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text(userName) // ✅ Displays User's Name
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
            
            HStack {
                Spacer()
                Text(card.provider)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(width: 300, height: 180)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.white.opacity(0.8) : Color.clear, lineWidth: 2)
        )
        .toolbar(.hidden, for: .tabBar) // ✅ Hide bottom navigation bar

    }
}

// ✅ Summary Row Component
struct SummaryRow: View {
    let title: String
    let price: String
    let isBold: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .bold(isBold)
            Spacer()
            Text(price)
                .foregroundColor(.white)
                .bold(isBold)
        }
    }
}


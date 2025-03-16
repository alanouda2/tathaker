import SwiftUI
import Firebase
import FirebaseAuth

struct FakePaymentView: View {
    let event: Event
    @State private var cardNumber = ""
    @State private var nameOnCard = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var paymentSuccess = false
    @State private var paymentMethod = "Credit Card"
    @State private var errorMessage: String?

    @State private var navigateToConfirmation = false // ✅ New state for navigation

    var body: some View {
        VStack {
            Text("Payment for \(event.title)")
                .font(.title2)
                .padding()

            Picker("Payment Method", selection: $paymentMethod) {
                Text("Credit/Debit Card").tag("Credit Card")
                Text("Apple Pay").tag("Apple Pay")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if paymentMethod == "Credit Card" {
                VStack(alignment: .leading) {
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)

                    TextField("Name on Card", text: $nameOnCard)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)

                    HStack {
                        TextField("MM/YY", text: $expiryDate)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)

                        TextField("CVV", text: $cvv)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }

            Button(action: processFakePayment) {
                Text("Pay Now")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            // ✅ Navigation to Confirmation Page
            NavigationLink(destination: TicketConfirmationView(event: event), isActive: $navigateToConfirmation) {
                EmptyView()
            }
        }
        .padding()
    }

    // ✅ Process Payment and Navigate to Confirmation
    func processFakePayment() {
        if paymentMethod == "Credit Card" {
            if cardNumber.count != 16 || expiryDate.isEmpty || cvv.count != 3 {
                errorMessage = "Invalid card details. Please check and try again."
                return
            }
        }

        errorMessage = nil
        saveTicketToFirebase()
        navigateToConfirmation = true // ✅ Navigate to confirmation
    }

    // ✅ Store Ticket in Firestore
    func saveTicketToFirebase() {
        let userID = Auth.auth().currentUser?.uid ?? "guest"
        let db = Firestore.firestore()
        let ticketData: [String: Any] = [
            "userID": userID,
            "eventID": event.id,
            "eventTitle": event.title,
            "eventDate": event.date,
            "eventLocation": event.location,
            "paymentMethod": paymentMethod,
            "ticketQR": generateQRCode(eventID: event.id, userID: userID)
        ]
        db.collection("tickets").addDocument(data: ticketData) { error in
            if let error = error {
                print("Error saving ticket: \(error)")
            } else {
                print("Ticket saved successfully!")
            }
        }
    }

    // ✅ Generate Fake QR Code URL
    func generateQRCode(eventID: String, userID: String) -> String {
        return "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=\(eventID)_\(userID)"
    }
}

import SwiftUI

struct TicketConfirmationView: View {
    let event: Event
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color(hex: "#D6E6F2")
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Image(systemName: "ticket.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)

                Text("Your Ticket is Booked!")
                    .font(.title)
                    .fontWeight(.bold)

                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.gray)

                Text(event.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                AsyncImage(url: URL(string: generateQRCode(eventID: event.id))) { image in
                    image.resizable()
                         .scaledToFit()
                         .frame(width: 150, height: 150)
                } placeholder: {
                    ProgressView()
                }
                .padding()

                // Done Button to go back to Event List
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
    }

    // ✅ Generate QR Code URL
    func generateQRCode(eventID: String) -> String {
        let userID = "guest" // Ideally, get this from Firebase Auth
        return "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=\(eventID)_\(userID)"
    }
}

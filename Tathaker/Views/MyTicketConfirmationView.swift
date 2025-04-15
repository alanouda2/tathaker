import SwiftUI

struct MyTicketConfirmationView: View {
    let ticket: BookedTicket
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tabRouter: TabRouter

    @Binding var openHome : Bool
    
    var body: some View {
        ZStack {
            Color(hex: "#D6E6F2").ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer(minLength: 30)

                Image(systemName: "ticket.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(hex: "#2A4D69"))

                Text("Ticket Booked!")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color(hex: "#2A4D69"))

                VStack(spacing: 10) {
                    Text(ticket.eventTitle)
                        .font(.headline)
                        .foregroundColor(.black)

                    Text(ticket.bookingTime)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 3)
                .padding(.horizontal)

                // QR Code
                AsyncImage(url: URL(string: generateQRCode(eventID: ticket.id))) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                } placeholder: {
                    ProgressView()
                }
                .padding()

                Spacer()

                // Done Button
                Button(action: {
                    
                    openHome = true
                    presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("Done")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2A4D69"))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }

    // ✅ QR Code Generator
    func generateQRCode(eventID: String) -> String {
        let userID = "guest" // Replace with Auth if needed
        return "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=\(eventID)_\(userID)"
    }
}

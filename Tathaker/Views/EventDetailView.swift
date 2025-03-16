import SwiftUI

struct EventDetailView: View {
    let event: Event
    @State private var navigateToPayment = false

    var body: some View {
        VStack(spacing: 20) {
            // ✅ Display Image from Asset or URL
            if let imageName = event.imageName, !imageName.isEmpty {
                Image(imageName) // ✅ Use asset image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(10)
            } else if let imageUrl = event.imageUrl, !imageUrl.isEmpty, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .frame(height: 250)
                .cornerRadius(10)
            } else {
                Image(systemName: "photo") // Fallback if no image available
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .foregroundColor(.gray)
            }

            // ✅ Event Title
            Text(event.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            // ✅ Event Details
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "calendar")
                    Text("Date: \(event.date)")
                }

                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Location: \(event.location)")
                }

                HStack {
                    Image(systemName: "clock")
                    Text("Duration: \(event.timeEstimate)")
                }

                Text(event.description)
                    .font(.body)
                    .padding(.top, 5)
            }
            .font(.headline)
            .padding()

            // ✅ Book Ticket Button
            Button(action: {
                navigateToPayment = true
            }) {
                Text("Book Ticket")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)

        // ✅ Navigation to Payment View
        NavigationLink(
            destination: FakePaymentView(event: event),
            isActive: $navigateToPayment
        ) {
            EmptyView()
        }
        .hidden()
    }
}

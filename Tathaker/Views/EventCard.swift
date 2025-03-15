import SwiftUI

struct EventCard: View {
    let event: Event

    var body: some View {
        NavigationLink(destination: EventDetailsView(event: event)) {
            VStack(alignment: .leading) {
                if let image = UIImage(named: event.imageUrl) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                } else {
                    Image(systemName: "photo") // Placeholder if no image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                }

                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(event.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(event.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20) // Ticket-like rounded corners
            .shadow(radius: 3)
        }
        .buttonStyle(PlainButtonStyle()) // ✅ Remove default NavigationLink styling
    }
}

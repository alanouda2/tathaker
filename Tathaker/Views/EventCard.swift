import SwiftUI

struct EventCard: View {
    let event: Event

    var body: some View {
        NavigationLink(destination: EventDetailView(event: event)) { // ✅ Navigate to EventDetailView
            VStack(alignment: .leading) {
                
                // ✅ Display Image from Asset or URL
                if let imageName = event.imageName, !imageName.isEmpty {
                    Image(imageName) // ✅ Use local asset image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(height: 150)
                } else if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    } placeholder: {
                        Image(systemName: "photo") // ✅ Placeholder if no valid URL
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .foregroundColor(.gray)
                            .frame(height: 150)
                    }
                } else {
                    // ✅ If no image available, show placeholder
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .foregroundColor(.gray)
                        .frame(height: 150)
                }

                // ✅ Event Details
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
            .cornerRadius(20) // ✅ Rounded corners for ticket-like effect
            .shadow(radius: 3)
        }
        .buttonStyle(PlainButtonStyle()) // ✅ Remove default NavigationLink styling
    }
}

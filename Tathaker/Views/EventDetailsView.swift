import SwiftUI
import MapKit

struct EventDetailsView: View {
    let event: Event // ✅ Event object with correct model

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                // ✅ HEADER with Back & Share Buttons
                HStack {
                    Button(action: {
                        // Action to go back
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Action to share event
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // ✅ EVENT IMAGE
                AsyncImage(url: URL(string: event.imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 180)
                }
                .scaledToFit()
                .cornerRadius(10)
                .padding(.horizontal)

                // ✅ EVENT DETAILS
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)

                    Text("Date: \(event.date)")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))

                    Text("Location: \(event.location)")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))

                    Text("Duration: \(event.timeEstimate)")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal)

                // ✅ MAP with "GET DIRECTIONS" BUTTON ON BOTTOM-LEFT
                ZStack(alignment: .bottomLeading) { // ✅ Align button to bottom-left
                    MapView()
                        .frame(height: 180) // ✅ Increased height
                        .cornerRadius(10)
                        .padding(.horizontal)

                    Button(action: {
                        // Open maps for directions
                    }) {
                        Text("Get Directions")
                            .foregroundColor(.black)
                            .bold()
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(Color.gray.opacity(0.2)) // ✅ Light gray shade
                            .cornerRadius(8)
                    }
                    .padding(.leading, 24) // ✅ Push to left corner
                    .padding(.bottom, 10) // ✅ Slight padding from bottom
                }

                // ✅ BOOK TICKETS BUTTON (Darker Blue)
                Button(action: {
                    // Action to book tickets
                }) {
                    Text("Book Tickets")
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 20/255, green: 40/255, blue: 65/255)) // ✅ Darker Blue
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .background(Color.customDarkBlue.edgesIgnoringSafeArea(.all))
    }
}

// ✅ Dummy MapView (Placeholder)
struct MapView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "map.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            )
    }
}

// ✅ PREVIEW
struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailsView(event: Event(
            id: "1",
            data: [
                "title": "Baladna Park",
                "date": "March 15, 2025",
                "location": "Al Khor",
                "time_estimate": "2 hours",
                "image_url": "https://your-image-url.com"
            ]
        ))
    }
}

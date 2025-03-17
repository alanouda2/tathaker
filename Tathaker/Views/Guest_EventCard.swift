//
//  Guest_EventCard.swift
//  Tathaker
//
//  Created by Bullshit  on 17/03/2025.
//
import SwiftUI

struct Guest_EventCard: View {
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Inject ViewModel

    let event: Event

    var body: some View {
        NavigationLink(destination: Guest_EventDetailsView(event: event).environmentObject(userViewModel) ) { // ✅ Navigate to EventDetailView
            VStack(alignment: .leading) {
                
                // ✅ Display Image from Asset or URL
                if let imageName = event.imageName, !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()  // ✅ Ensure it fills the frame properly
                        .frame(height: 180)  // ✅ Adjust height for a better look
                        .clipped()  // ✅ Prevents overflow
                        .cornerRadius(10)
                } else if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()  // ✅ Ensure it fills the frame properly
                            .frame(height: 180)  // ✅ Adjust height
                            .clipped()  // ✅ Prevents overflow
                            .cornerRadius(10)
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .foregroundColor(.gray)
                            .frame(height: 180) // ✅ Ensure placeholder matches real images
                    }
                } else {
                    // ✅ If no image available, show placeholder
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .foregroundColor(.gray)
                        .frame(height: 180)
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
            .frame(maxWidth: UIScreen.main.bounds.width - 40) // ✅ Matches search bar width

            .background(Color.white)
            .cornerRadius(20) // ✅ Rounded corners for ticket-like effect
            .shadow(radius: 3)
        }
        .buttonStyle(PlainButtonStyle()) // ✅ Remove default NavigationLink styling
    }
}


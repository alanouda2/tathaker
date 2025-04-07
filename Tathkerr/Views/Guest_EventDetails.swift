import SwiftUI
import MapKit

struct Guest_EventDetailsView: View {
    let event: Event
    @Environment(\.presentationMode) var presentationMode // ✅ Enables back navigation
    @State private var navigateToLogin = false // ✅ Redirects to login instead of payment
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Inject ViewModel


    var body: some View {
        VStack(spacing: 0) { // ✅ Ensures alignment
            // ✅ CUSTOM NAVBAR
            ZStack {
                Color(hex: "#2A4D69") // Dark Blue Header
                    .frame(height: 60)
                    .edgesIgnoringSafeArea(.top)

                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // ✅ Go Back
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }

                    Spacer()

                    Button(action: {
                        shareEvent()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                    }
                }
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    
                    // ✅ EVENT IMAGE WITH ROUNDED RECTANGLE
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.clear)
                            .frame(height: 220)
                            .overlay(
                                Group {
                                    if let imageName = event.imageName, !imageName.isEmpty {
                                        Image(imageName) // ✅ Use asset image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(minWidth: 200, maxWidth: 350, maxHeight: 220)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                    } else if let imageUrl = event.imageUrl, !imageUrl.isEmpty, let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .scaledToFit()
                                        .frame(height: 220)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                    } else {
                                        Image(systemName: "photo") // Default Placeholder
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 220)
                                            .foregroundColor(.gray)
                                    }
                                }
                            )
                            .padding(.horizontal)
                    }

                    // ✅ EVENT TITLE BELOW IMAGE
                    Text(event.title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    // ✅ DARK BLUE EVENT DETAILS CONTAINER (Aligned Correctly)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Opening Times:")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)

                        Text("8 AM - 8 PM Daily")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color(hex: "#2A4D69")) // ✅ Dark blue background
                    .cornerRadius(10)
                    .padding(.leading, -2)

                    // ✅ EVENT DESCRIPTION
                    Text(event.description)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    // ✅ MAP WITH "GET DIRECTIONS" BUTTON
                    ZStack(alignment: .bottomLeading) {
                        MapView(eventLocation: event.location)
                            .frame(height: 180)
                            .cornerRadius(10)
                            .padding(.horizontal)

                        Button(action: {
                            openMaps(for: event.location)
                        }) {
                            Text("Get Directions")
                                .foregroundColor(.black)
                                .bold()
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                        .padding(.leading, 24)
                        .padding(.bottom, 10)
                    }

                    // ✅ LOGIN BUTTON INSTEAD OF BOOKING TICKETS
                    Button(action: {
                        navigateToLogin = true
                    }) {
                        Text("Login to Book Tickets") // ✅ Updated text
                            .foregroundColor(.white)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#132A3E")) // ✅ Darker blue
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    Spacer()
                }
            }
        }
        .background(Color(hex: "#2A4D69").edgesIgnoringSafeArea(.all)) // ✅ Full dark background
        .navigationDestination(isPresented: $navigateToLogin) {
            // ✅ Redirecting to LoginView
            LoginView().environmentObject(userViewModel) 
        }
        .navigationBarHidden(true)
    }

    // ✅ Helper Functions (Moved Inside the Struct)
    private func shareEvent() {
        let text = "Check out this event: \(event.title) at \(event.location)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }

    private func openMaps(for location: String) {
        let query = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?q=\(query)") {
            UIApplication.shared.open(url)
        }
    }
}

// ✅ Dynamic MapView
struct MapView: View {
    let eventLocation: String

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


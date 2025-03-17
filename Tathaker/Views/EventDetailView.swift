import SwiftUI
import MapKit

struct EventDetailsView: View {
    let event: Event
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToPayment = false

    var body: some View {
            ZStack {
                Color(hex: "#2A4D69").edgesIgnoringSafeArea(.all) // ✅ Full dark background
                
                VStack(spacing: 0) {
                    // ✅ Custom Navbar (Back Button & Share Button)
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // ✅ Go Back
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(.white)) // ✅ Blend into background
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            shareEvent()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white) // ✅ White Share Button
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50) // ✅ Adjust for safe area
                    .navigationBarBackButtonHidden(true) // ✅ Hide Default iOS Back Button
                    
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            // ✅ EVENT IMAGE (Moved Up)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.clear)
                                    .frame(height: 220)
                                    .overlay(
                                        Group {
                                            if let imageName = event.imageName, !imageName.isEmpty {
                                                Image(imageName)
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
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 220)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    )
                                    .padding(.horizontal)
                            }
                            .padding(.top, 15) // ✅ Move Image Up Slightly
                            
                            // ✅ EVENT TITLE
                            Text(event.title)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            // ✅ OPENING TIMES
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
                            .background(Color(hex: "#2A4D69"))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
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
                            
                            // ✅ BOOK TICKETS BUTTON (Fixed)
                            NavigationLink(destination: FakePaymentView(event: event)) {
                                Text("Book Tickets")
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(hex: "#132A3E"))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                    }
                }
            }
        
        .ignoresSafeArea(.all, edges: .top) // ✅ Remove extra space at the top
        .navigationBarHidden(true) // ✅ Ensure Nav Bar is Hidden
        .navigationBarBackButtonHidden(true) // ✅ Hide default back button
        .toolbar(.hidden, for: .navigationBar) // ✅ Completely remove Navigation Bar
        .toolbar(.hidden, for: .tabBar) // ✅ Hide bottom navigation bar
    }
}

// ✅ Helper Functions
extension EventDetailsView {
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

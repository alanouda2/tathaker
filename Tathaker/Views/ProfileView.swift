import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var tickets: [Ticket] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // ✅ REMOVE HEADER FROM PROFILEVIEW (It's already in MainTabView)
            
            VStack {
                Text("Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                if let user = Auth.auth().currentUser {
                    Text("Username: \(user.email ?? "Unknown")")
                        .font(.headline)
                        .padding()

                    Text("Your Tickets")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()

                    if tickets.isEmpty {
                        Text("No past tickets")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(tickets) { ticket in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(ticket.eventTitle)
                                            .font(.headline)
                                        Text(ticket.eventDate)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text(ticket.eventLocation)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)

                                        AsyncImage(url: URL(string: ticket.ticketQR)) { image in
                                            image.resizable()
                                                 .scaledToFit()
                                                 .frame(height: 150)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                                }
                            }
                            .padding()
                        }
                    }

                    Button(action: {
                        try? Auth.auth().signOut()
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                } else {
                    Text("Please log in to view your profile")
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Spacer() // ✅ Ensures navigation stays at the bottom
        }
        .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
        .onAppear {
            print("Fetching tickets will be implemented later.")
        }
    }
}

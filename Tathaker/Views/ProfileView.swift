import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

struct ProfileView: View {
    @State private var username: String = "User Name"
    @State private var profileImageURL: String = ""
    @State private var navigateToEditProfile = false
    @State private var refreshTrigger = false

    @State private var stampsEarned = 5 // Example: 5 stamps earned

    var body: some View {
        VStack {
            ZStack {
                Color(red: 35/255, green: 56/255, blue: 84/255)
                    .frame(height: 120)
                    .ignoresSafeArea()

                VStack {
                    if let url = URL(string: profileImageURL), !profileImageURL.isEmpty {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }

                    Text(username)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding(.top, 40)
            }

            VStack(spacing: 12) {
                Button(action: { navigateToEditProfile = true }) {
                    ProfileOptionView(icon: "pencil", text: "Edit Profile")
                }

                Button(action: {}) {
                    ProfileOptionView(icon: "ticket", text: "Ticket History")
                }

                Button(action: {}) {
                    ProfileOptionView(icon: "lock", text: "Change Password")
                }

                Button(action: {}) {
                    ProfileOptionView(icon: "creditcard", text: "Manage Cards")
                }

                Button(action: {
                    try? Auth.auth().signOut()
                }) {
                    ProfileOptionView(icon: "arrow.left.circle.fill", text: "Log Out", isLogout: true)
                }
            }
            .padding()

            // Loyalty Card Section
            VStack(alignment: .leading) {
                Text("Loyalty Card")
                    .font(.headline)
                    .padding(.bottom, 5)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                    ForEach(0..<8, id: \ .self) { index in
                        Circle()
                            .fill(index < stampsEarned ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: index < stampsEarned ? "checkmark.seal.fill" : "seal")
                                    .foregroundColor(.white)
                            )
                    }
                }

                if stampsEarned >= 8 {
                    Text("\u{1F389} You've earned a free voucher!")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)

            Spacer()
        }
        .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchUserProfile()
        }
        .onChange(of: profileImageURL) { _ in
            fetchUserProfile()
        }
        .onChange(of: username) { _ in
            fetchUserProfile()
        }
        .onChange(of: refreshTrigger) { _ in
            fetchUserProfile()
        }
        .fullScreenCover(isPresented: $navigateToEditProfile) {
            EditProfileView(username: $username, profileImageURL: $profileImageURL, refreshTrigger: $refreshTrigger)
        }
    }

    func fetchUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                username = data["username"] as? String ?? "User Name"
                profileImageURL = data["profileImageURL"] as? String ?? ""
            }
        }
    }
}

struct ProfileOptionView: View {
    let icon: String
    let text: String
    var isLogout: Bool = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isLogout ? .red : .black)
            Text(text)
                .foregroundColor(isLogout ? .red : .black)
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

struct ProfileView: View {
    @State private var username: String = "User Name"
    @State private var profileImageURL: String = ""

    @State private var navigateToEditProfile = false
    @State private var refreshTrigger = false // ✅ Refresh trigger to reload profile

    var body: some View {
        VStack {
            ZStack {
                // ✅ Dark Blue Header
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

            Spacer()
        }
        .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchUserProfile()
        }
        .onChange(of: profileImageURL) { _ in
            fetchUserProfile() // ✅ Refresh when image changes
        }
        .onChange(of: username) { _ in
            fetchUserProfile() // ✅ Refresh when username changes
        }

        .onChange(of: refreshTrigger) { _ in
            fetchUserProfile() // ✅ Reload profile after EditProfileView is dismissed
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

// ✅ Custom view for profile options
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

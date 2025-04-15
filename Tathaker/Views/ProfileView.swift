import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

struct ProfileView: View {
    @State private var username: String = "User Name"
    @State private var profileImageURL: String = ""

    @State private var navigateToEditProfile = false
    @State private var refreshTrigger = false // ✅ Refresh trigger to reload profile
    
    @State private var showTicketHistory = false
    @State private var showChangePassword = false
    @EnvironmentObject var userViewModel: UserViewModel
    
    
    

    var body: some View {
        VStack {
            ZStack {
                // ✅ Dark Blue Header
//                Color(red: 35/255, green: 56/255, blue: 84/255)
//                    .frame(height: 120)
//                    .ignoresSafeArea()

                VStack {
                     if let localImage = loadLocalImage() {
                        Image(uiImage: localImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.black)
                    }

                    Text(username)
                        .font(.title2)
                        .foregroundColor(.black)
                    Text("Loyalty Points: \(userViewModel.totalPoints)")
                        .font(.headline)
                    Text(userViewModel.loyaltyTier)
                        .foregroundColor(Color(.systemOrange))
                }
                .padding(.top, 40)
            }

            VStack(spacing: 12) {
                Button(action: { navigateToEditProfile = true }) {
                    ProfileOptionView(icon: "pencil", text: "Edit Profile")
                }

                Button(action: {
                    self.showTicketHistory = true
                }) {
                    ProfileOptionView(icon: "ticket", text: "Ticket History")
                }

                Button(action: {
                    self.showChangePassword = true
                }) {
                    ProfileOptionView(icon: "lock", text: "Change Password")
                }

                Button(action: {}) {
                    ProfileOptionView(icon: "creditcard", text: "Manage Cards")
                }

                Button(action: {
                    userViewModel.logOut()//try? Auth.auth().signOut()
                }) {
                    ProfileOptionView(icon: "arrow.left.circle.fill", text: "Log Out", isLogout: true)
                }
            }
            .padding()

            Spacer()
        }
        .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
        
       
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Profile")
                    .font(.custom("PoetsenOne-Regular", size: 28))
                    .foregroundColor(.white)
            }
        }
        
        .onAppear {
            fetchUserProfile()
            userViewModel.fetchUserPoints()
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
            NavigationView {
                EditProfileView(username: $username, profileImageURL: $profileImageURL, refreshTrigger: $refreshTrigger, showView: $navigateToEditProfile)
                    .navigationBarTitle("Edit Profile", displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {
                        navigateToEditProfile = false
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    })
            }
        }
        
        .fullScreenCover(isPresented: $showTicketHistory) {
            TicketHistoryView()
        }
        .fullScreenCover(isPresented: $showChangePassword) {
            ChangePasswordView()
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
    
    private func loadLocalImage() -> UIImage? {
        guard let userID = Auth.auth().currentUser?.uid else { return nil }
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = folder.appendingPathComponent("profile_\(userID).jpg")
        return UIImage(contentsOfFile: fileURL.path)
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

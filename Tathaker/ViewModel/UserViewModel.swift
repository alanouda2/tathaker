import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isGuest: Bool = false // ✅ Track if user is a guest
    @Published var isLoggedIn: Bool = false // ✅ Add this property

    private var db = Firestore.firestore()

    init() {
        checkUserStatus() // ✅ Ensure status check at startup
    }

    func checkUserStatus() {
        if let firebaseUser = Auth.auth().currentUser {
            print("✅ User is logged in: \(firebaseUser.uid)")
            self.isGuest = false
            self.isLoggedIn = true // ✅ Update state once
            fetchUser(userID: firebaseUser.uid)
        } else {
            print("❌ No user logged in. Setting guest mode.")
            DispatchQueue.main.async {
                self.isGuest = true
                self.user = nil
                self.isLoggedIn = false // ✅ Ensure consistency

            }
        }
    }

    func fetchUser(userID: String) {
        print("🔍 Fetching user data for ID: \(userID)")
        db.collection("users").document(userID).getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error fetching user data: \(error.localizedDescription)")
                    self.user = nil
                    return
                }
                if let data = snapshot?.data() {
                    print("✅ User data found: \(data)")
                    self.user = User(
                        id: userID,
                        name: data["name"] as? String ?? "Guest",
                        email: data["email"] as? String ?? "",
                        phoneNumber: data["phoneNumber"] as? String ?? "",
                        profileImage: data["profileImage"] as? String ?? ""
                    )
                } else {
                    print("⚠️ No user data found in Firestore.")
                    self.user = nil
                }
            }
        }
    }
    func updateUser(username: String, phoneNumber: String, profileImageURL: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let userData: [String: Any] = [
            "username": username,
            "phoneNumber": phoneNumber,
            "profileImage": profileImageURL
        ]
        
        Firestore.firestore().collection("users").document(userID).updateData(userData) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully")
            }
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isGuest = true
                self.user = nil
            }
            print("🔴 User logged out.")
        } catch {
            print("⚠️ Error signing out: \(error.localizedDescription)")
        }
    }
}

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isGuest: Bool = false // Track if user is a guest

    private var db = Firestore.firestore()

    init() {
        checkUserStatus()
    }

    func checkUserStatus() {
        if let firebaseUser = Auth.auth().currentUser {
            // User is logged in
            self.isGuest = false
            fetchUser(userID: firebaseUser.uid)
        } else {
            // No user logged in → Guest Mode
            self.isGuest = true
        }
    }

    func fetchUser(userID: String) {
        db.collection("users").document(userID).getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let data = snapshot?.data() {
                    self.user = User(
                        id: userID,
                        name: data["name"] as? String ?? "Guest",
                        email: data["email"] as? String ?? "",
                        phoneNumber: data["phoneNumber"] as? String ?? "",
                        profileImage: data["profileImage"] as? String ?? ""
                    )
                }
            }
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            self.isGuest = true
            self.user = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

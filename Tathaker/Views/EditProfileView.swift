import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth
import PhotosUI // ✅ Import for SwiftUI's PhotosPicker

struct EditProfileView: View {
    @Binding var username: String
    @Binding var profileImageURL: String
    @Binding var refreshTrigger: Bool // ✅ Added this

    @State private var newUsername: String = ""
    @State private var selectedImageData: Data? // ✅ Store selected image data
    @State private var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            // ✅ HEADER
            ZStack {
                Color(hex: "#2A4D69")
                    .frame(height: 180)
                    .edgesIgnoringSafeArea(.top)

                VStack {
                    // Profile Image
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                    } else {
                        AsyncImage(url: URL(string: profileImageURL)) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.black)
                        }
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                    }

                    // ✅ CHANGE PICTURE BUTTON USING PhotosPicker
                    PhotosPicker(selection: Binding(
                        get: { nil },
                        set: { newItem in
                            if let newItem = newItem {
                                loadSelectedImage(newItem)
                            }
                        }
                    ), matching: .images, photoLibrary: .shared()) {
                        Text("Change Picture")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top, 5)
                    }
                }
            }
            .padding(.bottom, 20)

            // ✅ USERNAME INPUT
            VStack(alignment: .leading, spacing: 15) {
                Text("Username")
                    .font(.headline)
                    .foregroundColor(.black)

                TextField("Enter new username", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()

            // ✅ SAVE BUTTON
            Button(action: saveChanges) {
                Text("Save Changes")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#2A4D69"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
    }

    // ✅ LOAD SELECTED IMAGE FUNCTION
    private func loadSelectedImage(_ item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let data) = result, let data = data, let image = UIImage(data: data) {
                    self.selectedImageData = data
                    self.selectedImage = image
                }
            }
        }
    }

    // ✅ SAVE CHANGES FUNCTION
    private func saveChanges() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        var updates: [String: Any] = [:]

        // ✅ Update username if changed
        if !newUsername.isEmpty {
            updates["username"] = newUsername
        }

        // ✅ If an image is selected, upload it first
        if let selectedImageData = selectedImageData {
            uploadImage(selectedImageData) { url in
                if let url = url {
                    updates["profileImageURL"] = url.absoluteString
                }
                self.updateFirestore(db: db, userID: userID, updates: updates)
            }
        } else {
            self.updateFirestore(db: db, userID: userID, updates: updates)
        }
    }

    // ✅ FUNCTION TO UPDATE FIRESTORE WITH NEW DATA
    private func updateFirestore(db: Firestore, userID: String, updates: [String: Any]) {
        db.collection("users").document(userID).updateData(updates) { error in
            if error == nil {
                DispatchQueue.main.async {
                    // ✅ Update local values
                    if let newName = updates["username"] as? String {
                        self.username = newName
                    }
                    if let newProfileURL = updates["profileImageURL"] as? String {
                        self.profileImageURL = newProfileURL
                    }
                    self.refreshTrigger.toggle() // ✅ Notify ProfileView to refresh
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    // ✅ UPLOAD IMAGE FUNCTION
    private func uploadImage(_ imageData: Data, completion: @escaping (URL?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profileImages/\(userID).jpg")

        storageRef.putData(imageData, metadata: nil) { _, error in
            if error == nil {
                storageRef.downloadURL { url, _ in
                    completion(url)
                }
            } else {
                completion(nil)
            }
        }
    }
}

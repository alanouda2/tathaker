import SwiftUI
import Firebase
import FirebaseAuth
import PhotosUI

struct EditProfileView: View {
    @Binding var username: String
    @Binding var profileImageURL: String
    @Binding var refreshTrigger: Bool

    @State private var newUsername: String = ""
    @State private var selectedImageData: Data?
    @State private var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    @Binding var showView : Bool

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                ZStack {
                    VStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                        } else if let localImage = loadLocalImage() {
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
                    .padding(.top)
                }
                .padding(.bottom, 20)

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
        }
    }

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

    private func saveChanges() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        var updates: [String: Any] = [:]

        if !newUsername.isEmpty {
            updates["username"] = newUsername
        }

        if let selectedImageData = selectedImageData {
            if let fileURL = saveImageLocally(selectedImageData) {
                print("✅ Image saved locally at: \(fileURL.path)")
            }
        }

        updateFirestore(db: db, userID: userID, updates: updates)
    }

    private func updateFirestore(db: Firestore, userID: String, updates: [String: Any]) {
        db.collection("users").document(userID).updateData(updates) { error in
            DispatchQueue.main.async {
                if let newName = updates["username"] as? String {
                    self.username = newName
                }
                self.refreshTrigger.toggle()
                self.showView = false
            }
        }
    }

    private func saveImageLocally(_ imageData: Data) -> URL? {
        let fileManager = FileManager.default
        guard let userID = Auth.auth().currentUser?.uid else { return nil }

        let folder = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = folder.appendingPathComponent("profile_\(userID).jpg")

        do {
            try imageData.write(to: fileURL)
            return fileURL
        } catch {
            print("❌ Failed to save image: \(error)")
            return nil
        }
    }

    private func loadLocalImage() -> UIImage? {
        guard let userID = Auth.auth().currentUser?.uid else { return nil }
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = folder.appendingPathComponent("profile_\(userID).jpg")
        return UIImage(contentsOfFile: fileURL.path)
    }
}



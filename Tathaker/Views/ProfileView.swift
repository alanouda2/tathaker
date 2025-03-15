import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var isEditingProfile = false // Tracks if user clicks "Edit Profile"
    @State private var isLoggingIn = false // Tracks if guest clicks "Sign Up / Login"

    var body: some View {
        VStack {
            if userViewModel.isGuest {
                Spacer() // Pushes everything down

                        VStack {
                            Image(systemName: "person.crop.circle.badge.questionmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)

                            Text("You're browsing as a guest")
                                .font(.title2)
                                .bold()
                                .padding(.top, 10)

                            Text("Sign up or log in to access your profile and book events.")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()

                            Button(action: {
                                isLoggingIn = true // ✅ Correctly sets the state to show login screen
                            }) {
                                Text("Sign Up / Login")
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(Color.customDarkBlue)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.customLightBlue) // Ensure the whole section has background
                        .edgesIgnoringSafeArea(.top) // Prevents weird cut-offs

                        Spacer() // Makes sure it doesn't get squished

            } else if let user = userViewModel.user {
                // ✅ Logged-in User → Show Profile
                ZStack {
                    Rectangle()
                        .fill(Color.customDarkBlue)
                        .frame(height: 120)

                    HStack {
                        AsyncImage(url: URL(string: user.profileImage)) { image in
                            image.resizable()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))

                        Text(user.name)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    }
                    .padding(.top, 20)
                }

                VStack(spacing: 15) {
                    ProfileOption(title: "Edit Profile", icon: "pencil", action: {
                        isEditingProfile = true
                    })
                    ProfileOption(title: "Ticket History", icon: "ticket", action: {})
                    ProfileOption(title: "Change Password", icon: "lock", action: {})
                    ProfileOption(title: "Manage Cards", icon: "creditcard", action: {})
                    ProfileOption(title: "Log Out", icon: "arrow.backward.square", action: {
                        userViewModel.logOut()
                    })
                }
                .padding()
                .background(Color.customLightBlue)
                .cornerRadius(10)
            } else {
                // Loading Indicator
                ProgressView().onAppear {
                    if let userID = Auth.auth().currentUser?.uid {
                            userViewModel.fetchUser(userID: userID) // ✅ Fix
                        }
                }
            }
        }
        .background(Color.customLightBlue.edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $isEditingProfile) {
            EditProfileView(user: userViewModel.user!)
        }
        .fullScreenCover(isPresented: $isLoggingIn) {
            LoginView() // Navigate to Login/Signup Page
        }
    }
}

struct ProfileOption: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: User(
            id: "12345",
            name: "Alanoud Al Thani",
            email: "alanoud@example.com",
            phoneNumber: "+97412345678",
            profileImage: "https://example.com/profile.jpg"
        ))
    }
}

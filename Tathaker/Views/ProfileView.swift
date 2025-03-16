import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Use global user state
    @State private var navigateToLogin = false // ✅ Track navigation

    var body: some View {
        VStack {
            if userViewModel.isGuest || userViewModel.user == nil {
                // ✅ Guest Mode - Show login prompt with navigation
                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.gray.opacity(0.6))

                    Text("Welcome, Guest!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)

                    Text("Please log in or sign up to access your profile and tickets.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .foregroundColor(.gray)

                    Button(action: {
                        navigateToLogin = true // ✅ Trigger navigation
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.white)
                            Text("Login / Sign Up")
                                .font(.headline)
                        }
                        .frame(maxWidth: 220)
                        .padding()
                        .background(Color(hex: "#2A4D69")) // ✅ Dark Blue Button
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .fullScreenCover(isPresented: $navigateToLogin) {
                        LoginView().environmentObject(userViewModel) // Navigate to Login Page after delay
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "#D6E6F2")) // ✅ Light Blue Background
                .edgesIgnoringSafeArea(.all)
            } else {
                // ✅ Logged-in User - Show Profile UI
                VStack {
                    ZStack {
                        Color.blue
                            .frame(height: 100)
                            .cornerRadius(10)

                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .padding(.leading, -20)

                            Text(userViewModel.user?.name ?? "User")
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding(.leading, 20)
                    }
                    .padding()

                    // ✅ Profile Menu Options
                    VStack(spacing: 10) {
                        ProfileOptionRow(icon: "pencil", title: "Edit Profile")
                        ProfileOptionRow(icon: "ticket", title: "Ticket History")
                        ProfileOptionRow(icon: "lock", title: "Change Password")
                        ProfileOptionRow(icon: "creditcard", title: "Manage Cards")

                        Button(action: {
                            userViewModel.logOut() // ✅ Log out the user
                        }) {
                            ProfileOptionRow(icon: "arrow.left.to.line.alt", title: "Log Out")
                        }
                    }
                    .padding()
                }
                .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
            }
        }
        .onAppear {
            userViewModel.checkUserStatus()
        }
    }
}

// ✅ Profile Menu Row Component
struct ProfileOptionRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)

            Text(title)
                .font(.headline)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserViewModel()) // ✅ Inject ViewModel for preview
    }
}

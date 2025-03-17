import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var navigateToEditProfile = false

    var body: some View {
        NavigationStack { // ✅ Ensures navigation works
            VStack {
                // ✅ PROFILE HEADER SECTION
                ZStack {
                    Color(hex: "#2A4D69") // Dark blue header
                        .frame(height: 180)
                        .edgesIgnoringSafeArea(.top)

                    VStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 110, height: 110)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.black)
                            )
                            .offset(y: 20) // Moves profile picture slightly down

                        Text(userViewModel.user?.email ?? "User Name")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    }
                }
                .padding(.bottom, 20)

                // ✅ PROFILE OPTIONS
                VStack(spacing: 12) {
                    Button(action: {
                        navigateToEditProfile = true // ✅ Correctly updates state
                    }) {
                        ProfileOptionRow(icon: "pencil", title: "Edit Profile")
                    }

                    ProfileOptionRow(icon: "ticket.fill", title: "Ticket History") {}

                    ProfileOptionRow(icon: "lock.fill", title: "Change Password") {}

                    ProfileOptionRow(icon: "creditcard.fill", title: "Manage Cards") {}

                    ProfileOptionRow(icon: "arrow.left.circle.fill", title: "Log Out", isDestructive: true) {
                        userViewModel.logOut()
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
            .navigationDestination(isPresented: $navigateToEditProfile) {
                EditProfileView()
            }
        } // ✅ NavigationStack ensures links work!
    }
}

// ✅ PROFILE ROW COMPONENT
struct ProfileOptionRow: View {
    var icon: String
    var title: String
    var isDestructive: Bool = false
    var action: (() -> Void)?

    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? Color.red : Color(hex: "#132A3E"))

                Text(title)
                    .foregroundColor(isDestructive ? Color.red : .black)

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}

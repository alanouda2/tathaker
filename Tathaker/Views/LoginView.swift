import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @State private var navigateToLogin = false
    @State private var navigateToSignUp = false
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Inject ViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                // Splash Logo
                Image("splash_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                // Tathaker Logo
                Image("TathakerLogin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 600, height: 200)
                    .foregroundColor(Color(hex: "#2A4D69"))

                // Login Button
                Button(action: {
                    navigateToLogin = true
                }) {
                    Text("Login")
                        .font(.custom("NunitoSans-Bold", size: 20))
                        .frame(maxWidth: 300)
                        .padding()
                        .background(Color.customDarkBlue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .fullScreenCover(isPresented: $navigateToLogin) {
                    LoginAuthView().environmentObject(userViewModel) // ✅ Pass ViewModel
                }

                // Sign Up Button
                Button(action: {
                    navigateToSignUp = true
                }) {
                    Text("Sign Up")
                        .font(.custom("NunitoSans-Bold", size: 20))
                        .frame(maxWidth: 300)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.customDarkBlue, lineWidth: 2)
                        )
                }
                .fullScreenCover(isPresented: $navigateToSignUp) {
                    SignUpView().environmentObject(userViewModel) // ✅ Pass ViewModel
                }

                // Browse as Guest
                NavigationLink(destination: MainTabView().environmentObject(userViewModel)) { // ✅ Ensure ViewModel is passed
                    Text("Or Browse As Guest")
                        .font(.custom("NunitoSans-Regular", size: 16))
                        .foregroundColor(.black)
                        .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
            .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
        }
    }
}

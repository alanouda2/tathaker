import SwiftUI
import FirebaseAuth

struct GuestView: View {
    @State private var isLoggingIn = false
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Ensure global user state
    
    var body: some View {
        ZStack {
            Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all) // ✅ Full screen light blue

            VStack {
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
                        isLoggingIn = true // ✅ Navigate to Login
                    }) {
                        Text("Sign Up / Login")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color(hex: "#2A4D69")) // ✅ Custom Dark Blue
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(hex: "#D6E6F2")) // ✅ Light blue background inside
                
                Spacer() // Ensures correct spacing
            }
        }
        .fullScreenCover(isPresented: $isLoggingIn) {
            LoginView().environmentObject(userViewModel) // ✅ Use environment object
        }
    }
}

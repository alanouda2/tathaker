import SwiftUI

struct LoginView: View {
    @State private var navigateToEvents = false

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

                // Login Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        // Handle Sign Up
                    }) {
                        Text("Sign Up")
                            .font(.custom("NunitoSans-Bold", size: 20))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        // Handle Login
                    }) {
                        Text("Login In")
                            .font(.custom("NunitoSans-Bold", size: 20))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                    
                    // Browse as Guest Button
                    NavigationLink(destination: ContentView()) {
                        Text("Or Browse As Guest")
                            .font(.custom("NunitoSans-Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(.top, 10)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all)) // Light Blue Background
        }
    }
}

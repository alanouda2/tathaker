import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var isUserSignedUp = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Text("Create an Account")
                    .font(.custom("NunitoSans-Bold", size: 24))

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }

                Button(action: {
                    signUp()
                }) {
                    Text("Sign Up")
                        .font(.custom("NunitoSans-Bold", size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding()
            .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
            .fullScreenCover(isPresented: $isUserSignedUp) {
                EventListView()
            }
        }
    }

    private func signUp() {
        guard !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            errorMessage = "Passwords do not match or fields are empty."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isUserSignedUp = true
            }
        }
    }
}

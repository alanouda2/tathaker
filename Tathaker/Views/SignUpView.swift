import SwiftUI

import FirebaseAuth



struct SignUpView: View {
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Inject ViewModel

    @State private var email = ""

    @State private var password = ""

    @State private var confirmPassword = ""

    @State private var errorMessage: String?

    @State private var isUserSignedUp = false



    var body: some View {

        NavigationStack {

            VStack(spacing: 16) {

                Spacer()



                Text("Create an Account")

                    .font(.system(size: 30, weight: .black)) // Black is the heaviest weight

                    .foregroundColor(Color(hex: "#2A4D69"))

                    .multilineTextAlignment(.center)

                    .padding(.bottom, 15)

                

                VStack(spacing: 12) {

                    TextField("Email", text: $email)

                        .textFieldStyle(RoundedBorderTextFieldStyle())

                        .padding(.horizontal)

                        .autocapitalization(.none)



                    SecureField("Password", text: $password)

                        .textFieldStyle(RoundedBorderTextFieldStyle())

                        .padding(.horizontal)



                    SecureField("Confirm Password", text: $confirmPassword)

                        .textFieldStyle(RoundedBorderTextFieldStyle())

                        .padding(.horizontal)

                }



                // Error message display

                if let errorMessage = errorMessage {

                    Text(errorMessage)

                        .foregroundColor(.red)

                        .font(.caption)

                        .padding(.horizontal)

                }



                // Sign Up Button

                Button(action: {

                    signUp()

                }) {

                    Text("Sign Up")

                        .font(.custom("NunitoSans-Bold", size: 20))

                        .frame(maxWidth: 300) // Keeping button widths consistent

                        .padding()

                        .background(Color.customDarkBlue)

                        .cornerRadius(10)

                        .foregroundColor(.white)

                }

                .padding(.top, 10)



                Spacer()

            }

            .padding()

            .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))

            .fullScreenCover(isPresented: $isUserSignedUp) {

                MainTabView() // ✅ Show Home, Tickets, Profile
                    .environmentObject(userViewModel) // ✅ Inject ViewModel in root
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



struct SignUpView_Previews: PreviewProvider {

    static var previews: some View {

        SignUpView()

    }

}

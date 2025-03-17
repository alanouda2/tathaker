import SwiftUI

import FirebaseAuth



struct LoginAuthView: View {

    @State private var email = ""

    @State private var password = ""

    @State private var errorMessage: String?

    @State private var isUserLoggedIn = false
    
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Inject ViewModel


    var body: some View {

        NavigationStack {

            VStack(spacing: 20) {

                Spacer()



                Text("Login to Tathaker")

                    .font(.system(size: 30, weight: .black)) // Black is the heaviest weight

                    .foregroundColor(Color(hex: "#2A4D69"))

                    .multilineTextAlignment(.center)

                    .padding(.bottom, 15)



                VStack(spacing: 15) {

                    TextField("Email", text: $email)

                        .textFieldStyle(RoundedBorderTextFieldStyle())

                        .padding(.horizontal)

                        .autocapitalization(.none)



                    SecureField("Password", text: $password)

                        .textFieldStyle(RoundedBorderTextFieldStyle())

                        .padding(.horizontal)

                }



                if let errorMessage = errorMessage {

                    Text(errorMessage)

                        .foregroundColor(.red)

                        .font(.caption)

                        .padding(.horizontal)

                }



                Button(action: {

                    login()

                }) {

                    Text("Login")

                        .font(.custom("NunitoSans-Bold", size: 20))

                        .frame(maxWidth: .infinity)

                        .padding()

                        .background(Color(hex: "#2A4D69"))

                        .cornerRadius(10)

                        .foregroundColor(.white)

                }

                .padding(.horizontal)



                Spacer()

            }

            .padding()

            .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))

            .fullScreenCover(isPresented: $isUserLoggedIn) {

                MainTabView().environmentObject(userViewModel)

            }

        }

    }



    private func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                DispatchQueue.main.async {
                    userViewModel.checkUserStatus() // ✅ Ensure user data updates
                    if !isUserLoggedIn {
                                        isUserLoggedIn = true
                                    }
                }
            }
        }
    }

}



//struct LoginAuthView_Previews: PreviewProvider {

    //static var previews: some View {

        //LoginAuthView()

    //}

//}

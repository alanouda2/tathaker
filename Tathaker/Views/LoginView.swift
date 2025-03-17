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



                // Buttons Container

                VStack(spacing: 12) {

                    // Login Button

                    Button(action: {

                        navigateToLogin = true

                    }) {

                        Text("Login")

                            .font(.custom("NunitoSans-Bold", size: 20))

                            .frame(maxWidth: 300) // Ensuring same width

                            .padding()

                            .background(Color.customDarkBlue)

                            .cornerRadius(10)

                            .foregroundColor(.white)

                    }

                    .fullScreenCover(isPresented: $navigateToLogin) {

                        LoginAuthView().environmentObject(userViewModel)

                    }



                    // Sign Up Button

                    Button(action: {

                        navigateToSignUp = true

                    }) {

                        Text("Sign Up")

                            .font(.custom("NunitoSans-Bold", size: 20))

                            .frame(maxWidth: 300) // Ensuring same width

                            .padding()

                            .background(Color.white)

                            .cornerRadius(10)

                            .foregroundColor(.black)

                            .overlay(

                                RoundedRectangle(cornerRadius: 10)

                                    .stroke(Color.customDarkBlue, lineWidth: 2) // Adding border for contrast

                            )

                    }

                    .fullScreenCover(isPresented: $navigateToSignUp) {

                        SignUpView().environmentObject(userViewModel)

                    }

                }

                .padding(.top, 10)



                // Browse as Guest

                NavigationLink(destination: Guest_MainView().environmentObject(userViewModel)) {

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



//struct LoginView_Previews: PreviewProvider {

    //static var previews: some View {

        //LoginView()

    //}

//}

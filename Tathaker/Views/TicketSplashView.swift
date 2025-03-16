import SwiftUI

struct TicketSplashView: View {
    @State private var isActive = false
    @EnvironmentObject var userViewModel: UserViewModel // ✅ Inject ViewModel

    var body: some View {
        ZStack {
            // Full-screen light blue background
            Color(hex: "#D6E6F2")
                .edgesIgnoringSafeArea(.all) // Ensures full coverage

            VStack {
                Spacer()

                // Splash Logo (Ticket)
                Image("splash_logo") // Ensure it's in Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180) // Adjust size as needed

                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            LoginView().environmentObject(userViewModel) // Navigate to Login Page after delay
        }
    }
}

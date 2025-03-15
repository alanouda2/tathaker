import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            Color(hex: "#2a4d69") // Dark blue background
                .edgesIgnoringSafeArea(.top)
                .frame(height: 100) // Increase height for better spacing

            VStack {
                Image("Tathaker") // Make sure this is the correct asset name
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100) // Increased size
                    .padding(.top, 20) // Add spacing from the top
            }
        }
    }
}

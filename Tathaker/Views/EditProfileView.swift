import SwiftUI

struct EditProfileView: View {
    var body: some View {
        VStack(spacing: 20) {
            // ✅ HEADER WITH PROFILE PICTURE
            ZStack {
                Color(hex: "#2A4D69") // Dark blue header
                    .frame(height: 180)
                    .edgesIgnoringSafeArea(.top)

                VStack {
                    // PROFILE IMAGE (Static)
                    ZStack {
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
                    }
                    .offset(y: 20) // Moves the profile picture slightly down

                    Text("Change Picture")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.top, 5)
                }
            }
            .padding(.bottom, 20) // Pushes entire header down slightly

            // ✅ USER INPUT FIELDS (Static)
            VStack(alignment: .leading, spacing: 15) {
                CustomTextField(title: "Email", text: .constant("user@example.com"), isDisabled: true)
                CustomTextField(title: "Phone Number", text: .constant("+123456789"))
            }
            .padding(.horizontal)

            Spacer()

            // ✅ UPDATE BUTTON (No Action for Now)
            Button(action: {}) {
                Text("Update")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#2A4D69"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .background(Color(hex: "#D6E6F2").edgesIgnoringSafeArea(.all))
    }
}

// ✅ Custom TextField for UI
struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var isDisabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)

            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .disabled(isDisabled)
        }
    }
}

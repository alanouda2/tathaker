import SwiftUI

struct EditProfileView: View {
    @State var user: User
    @Environment(\.presentationMode) var presentationMode // Allows dismissing the view

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.customDarkBlue)
                    .frame(height: 120)

                Circle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                    .offset(y: 50)
            }
            .padding(.bottom, 50)

            Text("Change Picture")
                .font(.headline)

            VStack(spacing: 15) {
                CustomTextField(title: "Username", text: $user.name)
                CustomTextField(title: "Email", text: $user.email)
                CustomTextField(title: "Phone Number", text: $user.phoneNumber)
            }
            .padding()

            Button(action: {
                // Save changes to Firebase
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Update")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.customDarkBlue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .background(Color.customLightBlue.edgesIgnoringSafeArea(.all))
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            TextField(title, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
        }
    }
}



struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: User(
            id: "123",
            name: "Alanoud Al Thani",
            email: "alanoud@example.com",
            phoneNumber: "+97412345678",
            profileImage: "https://example.com/profile.jpg"
        ))
    }
}

import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            Button(action: { selectedTab = 0 }) {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            }
            .frame(maxWidth: .infinity)

            Button(action: { selectedTab = 1 }) {
                VStack {
                    Image(systemName: "ticket.fill")
                    Text("Tickets")
                }
            }
            .frame(maxWidth: .infinity)

            Button(action: { selectedTab = 2 }) {
                VStack {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 5)
    }
}

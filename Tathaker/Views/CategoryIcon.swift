import SwiftUI

struct CategoryIcon: View {
    let category: Category

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .frame(width: 60, height: 60) // Fixed size for all icons
                    .shadow(radius: 2)

                Image(systemName: category.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30) // Ensures all icons are the same size
                    .foregroundColor(.black)
            }

            Text(category.name)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}

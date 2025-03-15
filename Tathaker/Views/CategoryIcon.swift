import SwiftUI

struct CategoryIcon: View {
    let category: Category

    var body: some View {
        VStack {
            Image(systemName: category.iconName)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(Circle())

            Text(category.name)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}

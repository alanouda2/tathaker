import SwiftUI

struct CategoryIcon: View {
    let category: Category
    @Binding var selectedCategory: String?
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill((selectedCategory == category.name) ? Color.accentColor : Color.white)
                    .frame(width: 40, height: 40) // Fixed size for all icons
                    //.shadow(radius: 2)

                Image(systemName: category.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20) // Ensures all icons are the same size
                    .foregroundColor((selectedCategory == category.name) ? Color.white : Color.black)
            }
            .padding(2)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke((selectedCategory == category.name) ? Color.blue : Color.clear, lineWidth: 1)
//            )

            Text(category.name)
                .font(.footnote)
                .foregroundColor(.black)
        }
        
    }
}

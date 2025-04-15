import SwiftUI

struct EventCard: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            // ✅ Image
            if let imageName = event.imageName, !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .clipped()
                    .cornerRadius(10)
            } else if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(height: 100)
                        .clipped()
                        .cornerRadius(10)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                        .foregroundColor(.gray)
                        .cornerRadius(10)
                }
                
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .foregroundColor(.gray)
                    .cornerRadius(10)
            }

            // ✅ Event Info
            Text(event.title)
                .font(.system(size: 12, weight: .bold))
                .lineLimit(2)
                .frame(height: 25)
                .multilineTextAlignment(.leading)
                .padding(.top, 10)
                

            Text(event.date)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .frame(height: 15, alignment: .top)

            Text(event.location)
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .lineLimit(2)
                .frame(height: 30, alignment: .top)
                .multilineTextAlignment(.leading)
        }
        //.padding(10)
       // .cornerRadius(12)
        //.shadow(radius: 2)
        .padding(.horizontal, 20)
    }
}

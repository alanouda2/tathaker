import Foundation

struct Event: Identifiable {
    var id: String  // Firestore uses String IDs
    var title: String
    var date: String
    var location: String
    var timeEstimate: String
    var imageUrl: String?
    var imageName: String? // ✅ Supports asset-based images
    var description: String

    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? "No Title"
        self.date = data["date"] as? String ?? "No Date"
        self.location = data["location"] as? String ?? "No Location"
        self.timeEstimate = data["time_estimate"] as? String ?? "N/A"
        self.imageUrl = data["image_url"] as? String  // ✅ URL-based images from Firestore
        self.imageName = data["image_name"] as? String  // ✅ Asset-based images
        self.description = data["description"] as? String ?? "No description available."
    }
}

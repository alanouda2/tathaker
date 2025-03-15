import Foundation

struct Event: Identifiable {
    var id: String  // Firestore uses String IDs
    var title: String
    var date: String
    var location: String
    var timeEstimate: String
    var imageUrl: String // Ensure this matches Firestore field

    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? "No Title"
        self.date = data["date"] as? String ?? "No Date"
        self.location = data["location"] as? String ?? "No Location"
        self.timeEstimate = data["time_estimate"] as? String ?? "N/A"
        self.imageUrl = data["image_url"] as? String ?? "" // Ensure correct mapping
    }
}

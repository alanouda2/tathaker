import Foundation

struct Ticket: Identifiable {
    var id = UUID()
    var eventTitle: String
    var eventDate: String
    var eventLocation: String
    var ticketQR: String

    init(id: String, data: [String: Any]) {
        self.id = UUID() // Generates a unique ID
        self.eventTitle = data["eventTitle"] as? String ?? "Unknown Event"
        self.eventDate = data["eventDate"] as? String ?? "Unknown Date"
        self.eventLocation = data["eventLocation"] as? String ?? "Unknown Location"
        self.ticketQR = data["ticketQR"] as? String ?? ""
    }
}

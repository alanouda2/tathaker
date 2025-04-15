import Foundation

struct Ticket: Identifiable {
    var id = UUID()
    var eventTitle: String
    var eventDate: String
    var eventLocation: String
    var ticketQR: String
    var quantity: Int = 1

    init(id: String, data: [String: Any]) {
        self.id = UUID() // Generates a unique ID
        self.eventTitle = data["eventTitle"] as? String ?? "Unknown Event"
        self.eventDate = data["eventDate"] as? String ?? "Unknown Date"
        self.eventLocation = data["eventLocation"] as? String ?? "Unknown Location"
        self.ticketQR = data["ticketQR"] as? String ?? ""
    }
    
    var eventDateTime: Date {
        // Replace this logic with real timestamp from Firestore if needed
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: "\(eventDate)") ?? Date.distantFuture
    }

    var eventDateFormatted: String {
        return eventDate // Or format to `dd MMM`
    }

   

    var barcodeNumber: String {
        return ticketQR ?? "000000000000" // fallback
    }
}

import SwiftUI
import Firebase

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []

    init() {
        fetchEvents()
    }

    func fetchEvents() {
        let db = Firestore.firestore()
        db.collection("events").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }

            DispatchQueue.main.async {
                self.events = snapshot?.documents.compactMap { doc -> Event? in
                    return Event(id: doc.documentID, data: doc.data())
                } ?? []
            }
        }
    }
}

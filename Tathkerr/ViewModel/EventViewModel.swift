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
    
    
    
//    func addEventsToFirestore(events: [MyEvent]) {
//        let db = Firestore.firestore()
//        let batch = db.batch()
//        
//        let eventsCollection = db.collection("events")
//        
//        for event in events {
//            let docRef = eventsCollection.document(event.id)  // Creates a unique document for each event
//            batch.setData([
//                "title": event.title,
//                "description": event.description,
//                "date": event.date,
//                "imageUrl": event.imageURL,
//                "image_name": event.image_name,
//                "location": event.location,
//                "category": event.category
//            ], forDocument: docRef)
//        }
//        
//        // Commit the batch write
//        batch.commit { error in
//            if let error = error {
//                print("Error adding events: \(error.localizedDescription)")
//            } else {
//                print("All events added successfully!")
//            }
//        }
//    }
}

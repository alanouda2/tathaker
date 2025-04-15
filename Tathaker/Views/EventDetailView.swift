import SwiftUI
import MapKit
import FirebaseAuth
import FirebaseFirestore


struct EventDetailsView: View {
    let event: Event
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var navigateToPayment = false
    @State private var showRatingDialog = false
    @State private var rating: Int = 0
    
    @State private var averageRating: Double = 0.0
    @State private var ratingsCount: Int = 0
    
    @State var openHome : Bool = false
    
    


    var body: some View {
        ZStack {
            
           
            
            Color(hex: "#2A4D69").edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // ✅ Custom Navbar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {
                        shareEvent()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .navigationBarBackButtonHidden(true)

                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        // ✅ Image
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.clear)
                                .frame(height: 220)
                                .overlay(
                                    Group {
                                        if let imageName = event.imageName, !imageName.isEmpty {
                                            Image(imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(minWidth: 200, maxWidth: 350, maxHeight: 220)
                                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                        } else if let imageUrl = event.imageUrl, !imageUrl.isEmpty, let url = URL(string: imageUrl) {
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .scaledToFit()
                                            .frame(height: 220)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                        } else {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 220)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                )
                                .padding(.horizontal)
                        }
                        .padding(.top, 15)

                        // ✅ Title
                        Text(event.title)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        
                       

                        // ✅ Rating Display
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .onTapGesture {
                                        showRatingDialog = true
                                    }
                            }
                            Text("Rate this event")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .onTapGesture {
                                    showRatingDialog = true
                                }
                        }
                        .padding(.horizontal)
                        
                        Text("⭐️ \(String(format: "%.1f", averageRating)) (\(ratingsCount))")
                            .foregroundColor(.yellow)
                        .padding(.horizontal)

                        // ✅ Times
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Opening Times:")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                            Text("8 AM - 8 PM Daily")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(Color(hex: "#2A4D69"))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        // ✅ Description
                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        // ✅ Map + Directions
                        ZStack(alignment: .bottomLeading) {
                            MapView(eventLocation: event.location)
                                .frame(height: 180)
                                .cornerRadius(10)
                                .padding(.horizontal)
                            Button(action: {
                                openMaps(for: event.location)
                            }) {
                                Text("Get Directions")
                                    .foregroundColor(.black)
                                    .bold()
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 15)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                            }
                            .padding(.leading, 24)
                            .padding(.bottom, 10)
                        }

                        // ✅ Book Tickets
                        if userViewModel.isLoggedIn {
                            NavigationLink(destination: FakePaymentView(event: event, openHome: $openHome)
                                .navigationBarBackButtonHidden()) {
                                Text("Book Tickets")
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(hex: "#132A3E"))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        } else {
                            Text("Book Tickets")
                                .foregroundColor(.white)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#132A3E"))
                                .cornerRadius(10)
                                .onTapGesture {
                                    userViewModel.isGuest = false
                                    userViewModel.checkUserStatus()
                                }
                        }
                    }
                }
            }

            // ✅ Rating Dialog
            if showRatingDialog {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                VStack(spacing: 16) {
                    Text("Rate This Event")
                        .font(.headline)
                        .foregroundColor(.black)

                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= rating ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    rating = index
                                }
                        }
                    }

                    Button("Submit") {
                        showRatingDialog = false
                           submitRating(rating)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(.horizontal, 30)
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            updateAverageRating()
               checkIfUserRated()
            
//            if openHome
//            {
//                withAnimation(nil) {
//                    presentationMode.wrappedValue.dismiss()
//                }
//                
//            }
            
        }
    }
    
    func checkIfUserRated() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("events").document(event.id).collection("ratings").document(userID).getDocument { doc, error in
            if let data = doc?.data(), let previous = data["rating"] as? Int {
                self.rating = previous
            }
        }
    }
    
    func submitRating(_ value: Int) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let ratingRef = db.collection("events").document(event.id).collection("ratings").document(userID)

        ratingRef.setData(["rating": value]) { error in
            if let error = error {
                print("Error saving rating: \(error)")
            } else {
                updateAverageRating()
            }
        }
    }
    
    func updateAverageRating() {
        let db = Firestore.firestore()
        db.collection("events").document(event.id).collection("ratings")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }

                let ratings = documents.compactMap { $0.data()["rating"] as? Int }
                let average = Double(ratings.reduce(0, +)) / Double(ratings.count)

                self.averageRating = average
                self.ratingsCount = ratings.count
                
                db.collection("events").document(event.id).updateData([
                    "averageRating": average,
                    "ratingsCount": ratings.count
                ])
            }
    }

    private func shareEvent() {
        let text = "Check out this event: \(event.title) at \(event.location)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }

    private func openMaps(for location: String) {
        let query = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?q=\(query)") {
            UIApplication.shared.open(url)
        }
    }
}


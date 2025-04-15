import SwiftUI
import Firebase

struct EventListView: View {
    @ObservedObject var viewModel = EventViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var selectedDateOption: String = "Next 6 Months"
    @State private var specificDate = Date()
    @EnvironmentObject var userViewModel: UserViewModel

    let dateOptions = ["Date", "1 Week", "1 Month", "3 Months", "6 Months"]
    
   
    
    
    let categories = [
        Category(name: "All", iconName: "house.fill"),
        Category(name: "Concerts", iconName: "music.note"),
        Category(name: "Sports", iconName: "sportscourt"),
        Category(name: "Theater", iconName: "theatermasks"),
        Category(name: "Markets", iconName: "cart"),
        Category(name: "Cultural", iconName: "globe.europe.africa"),
        Category(name: "Exhibition", iconName: "photo.on.rectangle"),
        Category(name: "Education", iconName: "book.fill"),
        Category(name: "Business", iconName: "briefcase.fill")
    ]

    var filteredEvents: [Event] {
        let today = Date()
        let calendar = Calendar.current

        let startDate: Date
        let endDate: Date

        switch selectedDateOption {
        case "Date":
            startDate = calendar.startOfDay(for: specificDate)
            endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? specificDate
        case "1 Week":
            startDate = today
            endDate = calendar.date(byAdding: .weekOfYear, value: 1, to: today) ?? today
        case "1 Month":
            startDate = today
            endDate = calendar.date(byAdding: .month, value: 1, to: today) ?? today
        case "3 Months":
            startDate = today
            endDate = calendar.date(byAdding: .month, value: 3, to: today) ?? today
        default: // "Next 6 Months"
            startDate = today
            endDate = calendar.date(byAdding: .month, value: 6, to: today) ?? today
        }

        return viewModel.events.filter { event in
            let matchesSearch = searchText.isEmpty ||
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.location.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedCategory == nil || event.category == selectedCategory || selectedCategory == "All"

            let eventDate = getDate(from: event.date)
            let matchesDate = eventDate >= startDate && eventDate <= endDate

            return matchesSearch && matchesCategory && matchesDate
        }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 35/255, green: 56/255, blue: 84/255)
                .frame(height: 120)
                .ignoresSafeArea(edges: .top)
                

//               VStack {
//                   Text("Tathaker")
//                       .font(.custom("Pacifico-Regular", size: 26)) // 👈 Custom font applied
//                       .foregroundColor(.white)
//                       .padding(.top, 50)
//                   Spacer()
//               }
            
            
            VStack(spacing: 0) {
                // ✅ Header
                

                // ✅ Search + Filters
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search by Event or Location", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    
                    
                    Text("Categories")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(categories) { category in
                                CategoryIcon(category: category, selectedCategory: $selectedCategory)
                                    .onTapGesture {
                                        self.selectedCategory = category.name
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                    
                    
                   
                        
                        
                        // Date Selection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Select Option")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .padding(.horizontal)

                            Picker("Date Option", selection: $selectedDateOption) {
                                ForEach(dateOptions, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            .font(.system(size: 8))
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                            if selectedDateOption == "Date" {
                                DatePicker("Date", selection: $specificDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .labelsHidden()
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 10)
                    
                    
                    

                    Text("Events")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal)
                    
                    
                    
                   
                    // ✅ Event List
//                    ScrollView {
//                        VStack(spacing: 15) {
//                            ForEach(filteredEvents) { event in
//                                NavigationLink(destination: EventDetailsView(event: event).environmentObject(userViewModel)) {
//                                    EventCard(event: event)
//                                        .frame(maxWidth: UIScreen.main.bounds.width + 60)
//                                        .padding(.horizontal, 16)
//                                }
//                            }
//                        }
//                        .padding(.top, 5)
//                    }
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredEvents) { event in
                                NavigationLink(destination: EventDetailsView(event: event).environmentObject(userViewModel)) {
                                    EventCard(event: event)
                                }
                            }
                        }
                        .padding()
                        
                    }

                    Spacer()
                }
                //.background(Color.yellow)
            }
            .background(Color(hex: "#D6E6F2"))
            .onAppear {
                viewModel.fetchEvents()
            }
            
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Tathaker")
                    .font(.custom("PoetsenOne-Regular", size: 28))
                    .foregroundColor(.white)
            }
        }
        
    }

    // Convert string date to Date format
    private func getDate(from dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: dateString) ?? Date.distantPast
    }
}

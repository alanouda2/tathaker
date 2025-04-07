import SwiftUI
import Firebase

struct EventListView: View {
    @ObservedObject var viewModel = EventViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var selectedDateOption: String = "Next 6 Months"
    @State private var specificDate = Date()
    @EnvironmentObject var userViewModel: UserViewModel

    let dateOptions = ["Specific Date", "Next Week", "Next Month", "Next 3 Months", "Next 6 Months"]

    var filteredEvents: [Event] {
        let today = Date()
        let calendar = Calendar.current

        let startDate: Date
        let endDate: Date

        switch selectedDateOption {
        case "Specific Date":
            startDate = calendar.startOfDay(for: specificDate)
            endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? specificDate
        case "Next Week":
            startDate = today
            endDate = calendar.date(byAdding: .weekOfYear, value: 1, to: today) ?? today
        case "Next Month":
            startDate = today
            endDate = calendar.date(byAdding: .month, value: 1, to: today) ?? today
        case "Next 3 Months":
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

            let matchesCategory = selectedCategory == nil || event.category == selectedCategory

            let eventDate = getDate(from: event.date)
            let matchesDate = eventDate >= startDate && eventDate <= endDate

            return matchesSearch && matchesCategory && matchesDate
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // ✅ Header
            ZStack {
                Color(red: 35/255, green: 56/255, blue: 84/255)
                    .frame(height: 120)
                    

                Image("Tathaker")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.top, 30)
            }
            .ignoresSafeArea(edges: .top)

            // ✅ Search + Filters
            VStack(spacing: 10) {
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
                

                // Date Selection
                VStack(alignment: .leading) {
                    Text("Select Date Option")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal)

                    Picker("Date Option", selection: $selectedDateOption) {
                        ForEach(dateOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    if selectedDateOption == "Specific Date" {
                        DatePicker("Select Date", selection: $specificDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical, 10)

                // ✅ Event List
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(filteredEvents) { event in
                            NavigationLink(destination: EventDetailsView(event: event)) {
                                EventCard(event: event)
                                    .frame(maxWidth: UIScreen.main.bounds.width + 60)
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.top, 5)
                }

                Spacer()
            }
        }
        .background(Color(hex: "#D6E6F2"))
        .onAppear {
            viewModel.fetchEvents()
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
